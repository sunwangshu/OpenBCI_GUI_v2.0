//////////////////////////////////////////////////////////////////////////
//
//		Playground Class
//		Created: 11/22/14 by Conor Russomanno
//		An extra interface pane for additional GUI features
//
//////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------
//                       Global Variables & Instances
//------------------------------------------------------------------------

Playground playground;

//------------------------------------------------------------------------
//                       Global Functions
//------------------------------------------------------------------------

//------------------------------------------------------------------------
//                       Classes
//------------------------------------------------------------------------

class Playground {

  //button for opening and closing
  float x, y, w, h;
  color boxBG;
  color strokeColor;
  float topMargin, bottomMargin;

  boolean isOpen;
  boolean collapsing;

  Button collapser;

  Playground(int _topMargin) {

    topMargin = _topMargin;
    bottomMargin = helpWidget.h;

    isOpen = false;
    collapsing = true;

    boxBG = color(255);
    strokeColor = color(138, 146, 153);
    collapser = new Button(0, 0, 20, 60, "<", 14);

    x = width;
    y = topMargin;
    w = 0;
    h = height - (topMargin+bottomMargin);
  }

  public void update() {
    // verbosePrint("uh huh");
    println(q.keyOutput, q.stageOutput);
    if (collapsing) {
      collapse();
    } else {
      expand();
    }

    if (x > width) {
      x = width;
    }
  }

  public void draw() {
    // verbosePrint("yeaaa");
    pushStyle();
    fill(boxBG);
    stroke(strokeColor);
    rect(width - w, topMargin, w, height - (topMargin + bottomMargin));
    textFont(f1);
    textAlign(LEFT, TOP);
    fill(bgColor);
    text("Developer Playground", x + 10, y + 10);
    // ss 
    if (isOpen) {
      fill(184, 220, 105);
      rectMode(CENTER);
      rect(x + w*0.5, y + h*0.15, w*0.8, h*0.05);
      rectMode(CORNER);
      fill(0);
      noStroke();
      textSize(16);
      textAlign(CENTER,CENTER);
      text("Click to begin math quiz.", x + w*0.5, y + h*0.15);
      textAlign(LEFT, BASELINE);
    }
    // end ss
    fill(255, 0, 0);
    collapser.draw(int(x - collapser.but_dx), int(topMargin + (h-collapser.but_dy)/2));
    popStyle();
  }

  boolean isMouseHere() {
    if (mouseX >= x && mouseX <= width && mouseY >= y && mouseY <= height - bottomMargin) {
      return true;
    } else {
      return false;
    }
  }

  boolean isMouseInButton() {
    verbosePrint("Playground: isMouseInButton: attempting");
    if (mouseX >= collapser.but_x && mouseX <= collapser.but_x+collapser.but_dx && mouseY >= collapser.but_y && mouseY <= collapser.but_y + collapser.but_dy) {
      return true;
    } else {
      return false;
    }
  }

  public void toggleWindow() {
    if (isOpen) {//if open
      verbosePrint("close");
      collapsing = true;//collapsing = true;
      isOpen = false;
      collapser.but_txt = "<";
    } else {//if closed
      verbosePrint("open");
      collapsing = false;//expanding = true;
      isOpen = true;
      collapser.but_txt = ">";
    }
  }

  public void mousePressed() {
    // ss
    // mathQuiz button
    float x0 = x + w*0.5;
    float y0 = y + h*0.15;
    float w0 = w*0.8;
    float h0 = h*0.05;
    if (abs(mouseX - x0) < w0/2 && abs(mouseY - y0) < h0/2) {
      q.startWorking();
      mathQuizOn = true;
    }
    // end ss
    verbosePrint("Playground >> mousePressed()");
  }

  public void mouseReleased() {
    verbosePrint("Playground >> mouseReleased()");
  }

  public void expand() {
    if (w <= width/3) {
      w = w + 50;
      x = width - w;
    }
  }

  public void collapse() {
    if (w >= 0) {
      w = w - 50;
      x = width - w;
    }
  }
};