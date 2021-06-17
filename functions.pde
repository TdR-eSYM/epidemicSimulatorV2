// https://forum.processing.org/two/discussion/27473/paste-and-copy-text
String GetTextFromClipboard () {
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
  if (text==null) 
    return "";
  return text;
}

Object GetFromClipboard (DataFlavor flavor) {

  Clipboard clipboard = getJFrame(getSurface()).getToolkit().getSystemClipboard();

  Transferable contents = clipboard.getContents(null);
  Object object = null; // the potential result 

  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try
    {
      object = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException e1) // Unlikely but we must catch it
    {
      println("Clipboard.GetFromClipboard() >> Unsupported flavor: " + e1);
      e1.printStackTrace();
    }
    catch (java.io.IOException e2)
    {
      println("Clipboard.GetFromClipboard() >> Unavailable data: " + e2);
      e2.printStackTrace() ;
    }
  }
  return object;
}

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}
