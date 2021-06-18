class TextBox{
  int x, y, sizex, sizey;
  String text = "";
  boolean focus = false;
  boolean release = true;
  color foreColor, backColor;
  TextBox(int x, int y, int sizex, int sizey, color foreColor, color backColor){
    this.x = x;
    this.y = y;
    this.sizey = sizey;
    this.sizex = sizex;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }
  
   void render(){
    if(focus){
      fill(240);
    }else{
      fill(backColor);
    }
    rect(x, y, sizex, sizey/4);
    
    fill(foreColor);
    textSize(sizey/5);
    text(text, x + 7, y + sizey/5);
  }
}
