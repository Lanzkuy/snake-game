public class Textbox {
  private String text;
  private int x;
  private int y;
  private int tWidth;
  private int tHeight;
  private boolean selected;
  
  
  Textbox(String text, int x, int y, int tWidth, int tHeight) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.tWidth = tWidth;
    this.tHeight = tHeight;
  }
  
  public void setText(String text) {
    this.text = text;
  }
  
  public String getText() {
    return text; 
  }
  
  public int getX() {
    return x; 
  }
  
  public int getY() {
    return y; 
  }
  
  public int getWidth() {
    return tWidth; 
  }
  
  public int getHeight() {
    return tHeight; 
  }
  
  void draw() {
    fill(255);
    rect(x, y, tWidth, tHeight);
    fill(0);
    textSize(24);
    text(text, x + 5, y + 27);
  }
  
  public void addText(char text) {
    if(textWidth(this.text + text) < tWidth) {
      this.text += text;
    }
  }
  
  public void backspace() {
    if (this.text.length() - 1 >= 0) {
       this.text = this.text.substring(0, this.text.length() - 1);
    }
  }
  
  boolean keyPressed(char KEY, int KEYCODE) {
    if (selected) {
      if (KEYCODE == (int)BACKSPACE) {
        backspace();
      } 
      else if (KEYCODE == 32) {
        addText(' ');
      } 
      else if (KEYCODE == (int)ENTER) {
        return true;
      } 
      else {
        boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Z');
        boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'z');
        boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
  
        if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber) {
           addText(KEY);
        }
      }
    }
    
    return false;
  }
  
  public boolean isHovered() {
    return mouseX >= x && 
           mouseX <= x + tWidth &&  
           mouseY >= y && 
           mouseY <= y + tHeight ? true : false;
  }
   
  public void Pressed() {
    if (isHovered()) {
       selected = true;
    } else {
       selected = false;
    }
  }
}
