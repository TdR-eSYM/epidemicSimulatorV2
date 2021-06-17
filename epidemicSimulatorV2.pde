import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

TextBox textBox = new TextBox(50, 50, 100, color(0), color(255));

void setup() {
  size(1280, 720);
}
void draw() {
  fill (255);
  square (0, 0, 720);
  fill (186, 230, 255);
  rect (720, 0, 560, 720);
  line (720, 45, 1280, 45);
  fill (0);
  textSize (20);
  text ("Epidemic simulator V2", 890, 30);
  
  textBox.render();
}
