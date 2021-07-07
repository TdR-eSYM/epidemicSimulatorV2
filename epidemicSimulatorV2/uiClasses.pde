class Graph {
  int xquadre;
  int yquadre;
  int xsize;
  int ysize;
  int [] g;
  int index;
  color c;
  
  Graph (int xquadre, int yquadre, int xsize, int ysize, color c){
    this.xquadre = xquadre;
    this.yquadre = yquadre;
    this.xsize = xsize;
    this.ysize = ysize;
    this.index = xquadre;
    this.g = new int[xsize + xquadre];
    this.c = c;
  }
  void render() {
    fill (255);
  rect (xquadre, yquadre, xsize, ysize);
  stroke (c);
  for (int i = 0; i < (xsize + xquadre); i++) {
      if (g[i] == 0) continue;
      line(i, g[i], i, (ysize + yquadre));
    }
    stroke(0);
  }
  void update(int data) {
    if (index == xsize + xquadre - 1) {
      clean();
    }
    g[index++] =yquadre + ysize - data;
  }

  private void clean() {
    for (int i = 0; i < xsize + xquadre; i++) {
      g[i] = 0;
    }
    index = xquadre;
  }
}

class Button {
  String name;
  int r;
  int g;
  int b;
  int x;
  int y;
  int sizex;
  int sizey;
  Button (String name, int r, int g, int b, int x, int y, int sizex, int sizey) {
    this.name = name;
    this.r = r;
    this.g = g;
    this.b = b;
    this.x = x;
    this.y = y;
    this.sizex = sizex;
    this.sizey = sizey;
  }
  void render() {

    if (mousePressed && ((mouseY > y && mouseY < y + sizey) && (mouseX > x && mouseX < x + sizex))) {
      fill ( r - 20, g - 20, b);
      buttonPressed(name);
    } else { 
      fill (r, g, b);
    }
    rect (x, y, sizex, sizey);
  }
}

class TextBox {
  int x, y, sizex, sizey;
  String text = "";
  boolean focus = false;
  boolean release = true;
  color foreColor, backColor;
  TextBox(int x, int y, int sizex, int sizey, color foreColor, color backColor) {
    this.x = x;
    this.y = y;
    this.sizey = sizey;
    this.sizex = sizex;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }

  void render() {
    if (focus) {
      fill(240);
    } else {
      fill(backColor);
    }
    rect(x, y, sizex, sizey/4);

    fill(foreColor);
    textSize(sizey/5);
    text(text, x + 7, y + sizey/5);
  }
}
