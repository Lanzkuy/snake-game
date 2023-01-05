class Button {
  private String text;
  private int x;
  private int y;
  private int bWidth;
  private int bHeight;
  
  Button(String text, int x, int y, int bWidth, int bHeight) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
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
    return bWidth; 
  }
  
  public int getHeight() {
    return bHeight; 
  }
  
  public void draw() {
    if(isHovered()) {
      strokeWeight(5);
      stroke(255);
    }
    else {
      noStroke();
    }
    
    fill(34,139,34);
    rect(x, y, bWidth, bHeight);
    textSize(20);
    fill(255);
    text(text, x + 120, y+25);
  }
  
  public boolean isPressed() {
    return mousePressed && 
           mouseX >= x && 
           mouseX <= x + bWidth &&  
           mouseY >= y && 
           mouseY <= y + bHeight ? true : false;
  }
  
  public boolean isHovered() {
    return mouseX >= x && 
           mouseX <= x + bWidth &&  
           mouseY >= y && 
           mouseY <= y + bHeight ? true : false;
  }
}
