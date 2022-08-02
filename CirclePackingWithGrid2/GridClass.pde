import java.util.HashSet;

class Grid<T> {
  
  Cell [][] cells;
  ArrayList<T> occupants;
  int pixW, pixH;
  int w, h;
  float cellW, cellH;
  
  Grid(float maxElementDiameter, int pixW, int pixH) {
    this.pixW = pixW;
    this.pixH = pixH;
    this.w = round(pixW / (maxElementDiameter));
    this.h = round(pixH / (maxElementDiameter));
    cells = new Cell[w][h];
    this.cellW = maxElementDiameter;
    this.cellH = maxElementDiameter;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        PVector pos = new PVector(i * cellW, j * cellH);
        cells[i][j] = new Cell(pos, cellW, cellH);
      }
    }
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        Cell c = cells[x][y];
        c.neighbors = getNeighbors(x, y);
      }
    }
    occupants = new ArrayList<T>();
  }
  
  Grid(int w, int h, int pixW, int pixH) {
    cells = new Cell[w][h];
    
    this.pixW = pixW;
    this.pixH = pixH;
    this.cellW = 1.0 * pixW / w;
    this.cellH = 1.0 * pixH / h;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        PVector pos = new PVector(i * cellW, j * cellH);
        cells[i][j] = new Cell(pos, cellW, cellH);
      }
    }
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        Cell c = cells[x][y];
        c.neighbors = getNeighbors(x, y);
      }
    }
    this.w = w;
    this.h = h;
    occupants = new ArrayList<T>();
  }
  
  void add(T t, float xPixPos, float yPixPos) {
    int x = int(xPixPos / cellW);
    int y = int(yPixPos / cellW);
    cells[x][y].occupants.add(t);
    occupants.add(t);
  }
  
  void add(PVector p) {
    int x = int(p.x / cellW);
    int y = int(p.y / cellW);
    cells[x][y].occupants.add(p);
  }
  
  ArrayList<T> getCellMembers(int x, int y) {
    return new ArrayList(cells[x][y].occupants);
  }
  
  Cell getCell(float xPixPos, float yPixPos) {
    int x = int(xPixPos / cellW);
    int y = int(yPixPos / cellW);
    return cells[x][y];
  }
  
  Cell getCell(int x, int y) {
    if (x < 0 || x >= w || y < 0 || y >= h) {
      return null;
    } else {
      return cells[x][y];
    }
  }
  
  ArrayList<Cell> getNeighbors(int x, int y) {
    ArrayList<Cell> results = new ArrayList<Cell>();
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        Cell c = getCell(x + i, y + j);
        if (c != null && !(i == 0 && j == 0)) {
          results.add(c);
        }
      }
    }
    return results;
  }
  
  void show() {
    for (Cell [] array : cells) {
      for (Cell c : array) {
        c.show();
      }
    }
  }
  
  void showVectors() {
    for (Cell [] array : cells) {
      for (Cell c : array) {
        c.showVectors();
      }
    }
  }
  
}

class Cell<T> {
    
  PVector pos;
  int id; 
  float w, h;
  color fillColor;
  ArrayList<Cell> neighbors;
  HashSet<T> occupants;
  boolean active;
  
  Cell(PVector pos, float w, float h) {
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.occupants = new HashSet<T>();
    this.neighbors = new ArrayList<Cell>();
  }
  
  void add(T t) {
    occupants.add(t);
  }
  
  void remove(T t) {
    occupants.remove(t);
  }
  
  void show() {
    noFill();
    stroke(255, 0, 0);
    if (active) {
      stroke(255, 0, 0);
    }
    strokeWeight(1);
    rect(pos.x, pos.y, w, h);
  }
  
  ArrayList<T> getOccupantsAndOccupantsOfNeighbors() {
    ArrayList<T> results = new ArrayList<T>();
    for (Cell c : neighbors) {
      results.addAll(c.occupants);
    }
    results.addAll(occupants);
    return results;
  }
  
  ArrayList<T> getOccupantsOfNeighbors() {
    ArrayList<T> results = new ArrayList<T>();
    for (Cell c : neighbors) {
      results.addAll(c.occupants);
    }
    return results;
  }
  
  void showVectors() {
    strokeWeight(4);
    for (T o : occupants) {
      PVector p = (PVector) o;
      point(p.x, p.y);
    }
  }
  
  boolean contains(float x, float y) {
    return x >= pos.x && y >= pos.y && x <= pos.x + w && y <= pos.y + h;
  }
  
}
