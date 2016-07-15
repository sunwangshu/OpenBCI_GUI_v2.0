class Quiz {
  // draw parameters
  float x, y, w, h;
  PFont font = createFont("Lucida Grande", 100);
  boolean showing = true;
  
  // game parameters
  int stage;  // 0 start, 1 test, 2(see result), 3 countdown end and restartable
  int score;

  int startTime;
  int duration = 60000;
  int timeLeft;
  int minutes;
  int seconds;

  int num1, num2;
  int answerCorrect;
  String answerStr;
  int answerNum;
  boolean entered;
  boolean pass;
  
  // display parameters
  String feedbackStr;
  int feedbackStartTime;
  int feedbackType;
  
  // output info
  int stageOutput;   // -1 0 1 21 20
  // -1 not in test
  // 0 start waiting (= restart), 
  // 1 input waiting
  // 21 correct waiting
  // 20 false waiting
  boolean keyOutput = false;  // true when key is down or see

  Quiz(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    stageOutput = -1;
    stage = 0;

    // display parameters
    feedbackType = -1;
    feedbackStartTime = 0;
    feedbackStr = "";  
  }

  void update() {
    w = width;
    h = height;
    switch(stage) {
      case 0:
        break;
        
      case 1:
        timeLeft = startTime + duration - millis();
        if (timeLeft > 0 ) {
          seconds = (timeLeft / 1000) % 60;
          minutes = (timeLeft / 1000) / 60;
        } else {
          keyOutput = false;  // data debugging
          stageOutput = 0;
          stage = 3;
        }
        // unless showing otherwise don't register key input
        if (showing) {
          if (keyPressed) {
            keyOutput = true;
          }
          else {
            keyOutput = false;
          }
        }
        
        if (feedbackType != -1) {
          if (millis() - feedbackStartTime <= 250) {
            if (feedbackType == 1) {
              feedbackStr = "Correct!";
              stageOutput = 21;
            } else {
              feedbackStr = "Try again?";
              stageOutput = 20;
            }
          }
          else {
            stageOutput = 1;
            feedbackStr = "";
            feedbackType = -1;
          }
        }
        break;
        
      case 3:
        break;
    }
    
  }

  void display() {
    translate(x,y);
    fill(0);
    rect(0,0,w,h);
    
    textFont(font);
    switch (stage) {
      case 0:
        fill(255);
        noStroke();
        textSize(0.058 * h);
        textAlign(CENTER, CENTER);
        text("Click to start quiz.", w/2, h/2);
        break;
        
      case 1:
        // unless showing otherwise don't show anything
        if (showing) {
          fill(255);
          noStroke();
          textSize(floor(0.058 * h));
          textAlign(LEFT, BASELINE);
          text(String.format("%02d", minutes) + ":" + String.format("%02d", seconds), 0.136*w, 0.22*h);
          
          textAlign(RIGHT, BASELINE);
          text("Score: " + score, 0.84*w, 0.22*h);
          
          textAlign(LEFT, BASELINE);
          textSize(0.08 * h);
          text(num1 + " + " + num2 + " = ?", 0.35*w, 0.46*h);
          
          textAlign(LEFT, TOP);
          if (!entered) {
            text(answerStr, 0.35*w, 0.50*h);
          } 
          textSize(0.058 * h);
          text(feedbackStr, 0.35*w, 0.50*h);
        }
        break;
        
      case 3:
        fill(255);
        noStroke();
        textSize(0.058 * h);
        textAlign(CENTER,CENTER);
        // if not showing then don't show score
        if (showing) {
          text("Your Score: " + score, w/2, h/2 - h/10);
        }
        text("Click to restart.", w/2, h/2 + h/10);
        break;
    }
    translate(-x,-y);
  }

  void retry() {
    answerStr = "";
    answerNum = 0;
    entered = false;
  }

  void newRound() {  // new round of quizes
    score = 0;
    startTime = millis();
    newQuiz();
  }
  
  void newQuiz() {    // new quiz    
    num1 = floor(random(10, 100));
    num2 = floor(random(10, 100));
    answerCorrect = num1 + num2;

    answerStr = "";
    answerNum = 0;
    entered = false;
    pass = false;
  } 

  void startWorking() {
    stage = 0;
    stageOutput = 0;
    keyOutput = false;
  }

  void stopWorking() {
    stageOutput = -1;
    keyOutput = false;
  }

  void myKeyPressed() {
    // add a key for shutting off the screen, thus record baseline brain state.
    if (key == 92) {
      showing = !showing;
    }
    switch(stage) {
      case 0:
        break;

      case 1:
        // unless showing otherwise forbid input
        if (showing) {
          if (key <= 57 && key >= 48) {
            if (answerStr.length() < 8)
              answerStr += key;
          }
          if (key == 8) {  // clear stuff
            if (answerStr.length() > 0) {
              answerStr = answerStr.substring(0, answerStr.length()-1);
            }
          } else if (key == ENTER) {
            if (!entered) {
              if (answerStr != "") {
                entered = true;
                answerNum = Integer.parseInt(answerStr);
                answerStr = "";
                
                feedbackStartTime = millis();
                
                if (answerNum == answerCorrect) {
                  score ++;
                  pass = true;
                  feedbackType = 1;
                  newQuiz();
                }
                else {
                  stageOutput = 20;
                  pass = false;
                  feedbackType = 0;
                  retry();
                }
              }
            }
          }
        }
        break;
        
      case 3:
        break;
    } 
    
  }
  
  void myMousePressed() {
    switch (stage) {
      case 0:
        newRound();
        stageOutput = 1;
        keyOutput = false;
        stage = 1;
        break;
        
      case 1: 
        break;
        
      case 3:
        newRound();
        stageOutput = 1;
        keyOutput = false;
        stage = 1;
        break;
    }
  }
  
}