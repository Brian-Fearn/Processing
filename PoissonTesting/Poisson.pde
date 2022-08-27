import java.util.Arrays;

class PoissonSampler {

  float minDist;
  int cellSize, widthInPix, heightInPix;
  int cellsPerRow, cellsPerColumn, sampleLimit;
  HashMap<Integer, Cell> cellIdMap = new HashMap<Integer, Cell>();
  ArrayList<PVector> active;
  ArrayList<PVector> points;
  
  PoissonSampler() {}
  
  void setParams(int widthInPix, int heightInPix, int sampleLimit, float minDist) {
    this.widthInPix = widthInPix;
    this.heightInPix = heightInPix;
    this.sampleLimit = sampleLimit;
    this.minDist = minDist;
    this.cellSize = int(minDist / sqrt(2));
    this.cellsPerRow = int(widthInPix / cellSize);
    this.cellsPerColumn = int(heightInPix / cellSize);
    this.widthInPix = cellSize * cellsPerRow;
    this.heightInPix = cellSize * cellsPerColumn;
    this.active = new ArrayList<PVector>();
    this.points = new ArrayList<PVector>();
    for (int i = 0; i < cellsPerColumn; i++) {
      for (int j = 0; j < cellsPerRow; j++) {
        int x = j * cellSize;
        int y = i * cellSize;
        PVector pos = new PVector(x, y);
        int id = getCellId(pos);
        Cell c = new Cell(pos, id, cellSize, cellSize);
        cellIdMap.put(id, c);
      }
    }
    for (Cell c : cellIdMap.values()) {
      ArrayList<Integer> ids = getNeighboringCellIds(c.id);
      ArrayList<Cell> neighbors = new ArrayList<Cell>();
      for (Integer id : ids) {
        neighbors.add(cellIdMap.get(id));
      }
      c.neighbors = neighbors;
    }
  }
  
  ArrayList<PVector> getPointsCircle(PVector center, float radius, int sampleLimit, float minDist) {
    ArrayList<PVector> results = getPointsRect(center.copy().sub(new PVector(radius, radius)), int(radius * 2), int(radius * 2), sampleLimit, minDist);
    ArrayList<PVector> toRemove = new ArrayList<PVector>();
    for (PVector p : results) {
      if (p.copy().sub(center).magSq() > radius * radius) {
        toRemove.add(p);
      }
    }
    results.removeAll(toRemove);
    return results;
  }
  
  ArrayList<PVector> getPointsPolygon(ArrayList<PVector> polygon, int sampleLimit, float minDist) {
    BoundBox bounds = new BoundBox(polygon);
    ArrayList<PVector> results = getPointsRect(bounds.topLeft, int(bounds.w), int(bounds.h), sampleLimit, minDist);
    ArrayList<PVector> toRemove = new ArrayList<PVector>();
    for (PVector p : results) {
      if (!polygonContains(polygon, p)) {
        toRemove.add(p);
      }
    }
    results.removeAll(toRemove);
    return results;
  }
  
  ArrayList<PVector> getPointsRect(PVector topLeft, int widthInPix, int heightInPix, int sampleLimit, float minDist) {
    this.widthInPix = widthInPix;
    this.heightInPix = heightInPix;
    this.sampleLimit = sampleLimit;
    this.minDist = minDist;
    this.cellSize = int(minDist / sqrt(2));
    this.cellsPerRow = int(widthInPix / cellSize);
    this.cellsPerColumn = int(heightInPix / cellSize);
    this.widthInPix = cellSize * cellsPerRow;
    this.heightInPix = cellSize * cellsPerColumn;
    this.active = new ArrayList<PVector>();
    this.points = new ArrayList<PVector>();
    
    for (int i = 0; i < cellsPerColumn; i++) {
      for (int j = 0; j < cellsPerRow; j++) {
        int x = j * cellSize;
        int y = i * cellSize;
        PVector pos = new PVector(x, y);
        int id = getCellId(pos);
        Cell c = new Cell(pos, id, cellSize, cellSize);
        cellIdMap.put(id, c);
      }
    }
    for (Cell c : cellIdMap.values()) {
      ArrayList<Integer> ids = getNeighboringCellIds(c.id);
      ArrayList<Cell> neighbors = new ArrayList<Cell>();
      for (Integer id : ids) {
        neighbors.add(cellIdMap.get(id));
      }
      c.neighbors = neighbors;
    }
    
    placeFirstPoint();
    while (!active.isEmpty()) {
      placeNewPoint();
    }
    // shift all the points relative to topLeft
    for (PVector p : points) {
      p.add(topLeft);
    }
    return points;
  }
  
  void showCells() {
    for (Cell c : cellIdMap.values()) {
      c.show();
    }
  }
  
  PVector placeFirstPoint() {
    PVector firstPoint = new PVector(random(widthInPix), random(heightInPix));
    int id = getCellId(firstPoint);
    Cell c = cellIdMap.get(id);
    c.occupants.add(firstPoint);
    active.add(firstPoint);
    return firstPoint;
  }
  
  PVector placeNewPoint(float minD) {
    PVector v = active.get(int(random(active.size())));
    int tries = 0;
    PVector candidate = null;
    Cell candidateCell = null;
    while (tries < sampleLimit) {
      candidate = PVector.random2D().mult(minD * random(1, 2)).add(v);
      if (candidate.x < 0 || candidate.x > widthInPix || candidate.y < 0 || candidate.y > heightInPix) {
        continue;
      }
      candidateCell = cellIdMap.get(getCellId(candidate));
      if (candidateCell == null) {
        candidate = null;
        continue;
      }
      ArrayList<Cell> neighbors = candidateCell.neighbors;
      for (Cell n : neighbors) {
        for (PVector occupant : n.occupants) {
          if (withinDistance(candidate, minD, occupant)) {
            candidate = null;
            break;
          }
        }
        if (candidate == null) { break; }
      }
      if (candidate != null) {
        candidateCell.occupants.add(candidate);
        active.add(candidate);
        points.add(candidate);
        break;
      }
      tries++;
    }
    if (candidate == null && tries == sampleLimit) {
      active.remove(v);
    }
    return candidate;
  }
  
  PVector placeNewPoint() {
    return this.placeNewPoint(minDist);
  }
  
  int getCellId(PVector pos) {
    int x = int(pos.x / cellSize);
    int y = int(pos.y / cellSize);
    return x + y * cellsPerRow;
  }
  
  ArrayList<Integer> getNeighboringCellIds(int id) {
    ArrayList<Integer> neighbors = new ArrayList<Integer>();
    boolean onLeftEdge = id % cellsPerRow == 0;
    boolean onRightEdge = id % cellsPerRow == (cellsPerRow - 1);
    boolean onTopEdge = id / cellsPerRow == 0;
    boolean onBottomEdge = id / cellsPerRow == (cellsPerColumn - 1);
    // might make your eyes bleed a little 
    neighbors.addAll(Arrays.asList(
      (!onLeftEdge && !onTopEdge) ? id - cellsPerRow - 1 : -1, !onTopEdge ? id - cellsPerRow : -1, (!onRightEdge && !onTopEdge) ? id - cellsPerRow + 1 : -1, 
      !onLeftEdge ? id - 1 : -1, id,
        !onRightEdge ? id + 1 : -1, 
      (!onLeftEdge && !onBottomEdge) ? id + cellsPerRow - 1 : -1, !onBottomEdge ? id + cellsPerRow : -1, (!onRightEdge && !onBottomEdge) ? id + cellsPerRow + 1 : -1));
    neighbors.removeAll(Arrays.asList(-1));
    return neighbors;
  }
  
  class Cell {
    
    PVector pos;
    int id, w, h;
    color fillColor;
    ArrayList<Cell> neighbors;
    ArrayList<PVector> occupants;
    boolean active;
    
    Cell(PVector pos, int id, int w, int h) {
      this.pos = pos;
      this.id = id;
      this.w = w;
      this.h = h;
      this.occupants = new ArrayList<PVector>();
    }
    
    void show() {
      noFill();
      stroke(0);
      if (active) {
        fill(255, 0, 0);
      }
      strokeWeight(2);
      rect(pos.x, pos.y, w, h);
      for (PVector p : occupants) {
        strokeWeight(5);
        stroke(0, 0, 255);
        point(p.x, p.y);
      }
    }
    
    boolean contains(PVector v) {
      return v.x >= pos.x && v.y >= pos.y && v.x <= pos.x + w && v.y <= pos.y + h;
    }
    
  }
  
  class BoundBox {
    
    PVector topLeft;
    float w, h;
    
    BoundBox(ArrayList<PVector> list) {
      float minX = list.get(0).x;
      float minY = list.get(0).y;
      float maxX = list.get(0).x;
      float maxY = list.get(0).y;
      for (int i = 1; i < list.size(); i++) {
        PVector v = list.get(i);
        if (v.x < minX) {
          minX = v.x;
        }
        if (v.y < minY) {
          minY = v.y;
        }
        if (v.x > maxX) {
          maxX = v.x;
        }
        if (v.y > maxY) {
          maxY = v.y;
        }
      }
      this.topLeft = new PVector(minX, minY);
      this.w = maxX - minX;
      this.h = maxY - minY;
    }
    
  }
}
