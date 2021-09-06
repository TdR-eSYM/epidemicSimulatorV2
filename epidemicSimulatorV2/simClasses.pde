class Simulation {
  int state;
  Walker[] walkers;
  int agentNum, agentSize, infected, dead, immune, initialInf, STD_DEV, MEAN;
  float startInfProb, infProb, deathProb, recProb;

  int renderLength = 0;
  int dataOffset = 0;
  int frameNum = 0;
  int startTime = 0;
  int pauseTimestamp = 0;
  int pauseTime = 0;
  
  byte[] bakeData;
  ByteBuffer simData;

  boolean gMovement;
  int fixedSpeed;
  int maxAngleChange;

  float sDistance, sToughness, sReaction;
  float testDelay, testRelaiability;

  Simulation(int agentNum, int agentSize, int initialInf, int STD_DEV, int MEAN, boolean gMovement) {
    this.agentNum = agentNum;
    this.agentSize = agentSize;
    this.initialInf = initialInf;
    this.STD_DEV = STD_DEV;
    this.MEAN = MEAN;
    this.gMovement = gMovement;
    state = SimStates.STOPPED;
  }

  void setup() {
    if (renderEngineCheck.pressed) {
      Process renderProc = launch("cd " + dataPath("RenderEngine/ && simRender.exe " + str(renderLength) + " " + str(agentNum)));
      try {
        renderProc.waitFor();
      } 
      catch (InterruptedException e) {
        println(e);
      }
      if (renderProc.exitValue() != 0) {
        println("An error has ocurred with the renderEngine - Nonzero exitcode");
        return;
      }
      bakeData = loadBytes(dataPath("RenderEngine/export.sim"));
      simData = ByteBuffer.wrap(bakeData).order(ByteOrder.LITTLE_ENDIAN);
    } else {
      walkers = new Walker[agentNum];
      for (int i = 0; i < agentNum-infected; i++) {
        float xPos = random(0, 720);
        float yPos = random(0, height);

        walkers[i] = new Walker(xPos, yPos, agentSize, AgentStates.SUSCEPTIBLE);
      }
      for (int i = 0; i < infected; i++) {
        float xPos = random(0, 720);
        float yPos = random(0, height);

        walkers[i+(agentNum-infected)] = new Walker(xPos, yPos, agentSize, AgentStates.INFECTED);
      }
    }
    initialInf = infected;
    state = SimStates.RUNNING;
    startTime = millis();
    pauseTime = 0;
  }

  void tick() {
    if (state == SimStates.STOPPED) return;
    if (state == SimStates.RUNNING) {
      infected = 0;
      dead = 0;
      immune = 0;
    }
    if (renderEngineCheck.pressed) {
      if (renderLength <= frameNum) {
        this.stop();
        frameNum = 0;
        dataOffset = 0;
      }
      if (state == SimStates.PAUSED) return;
      // For every agent (walker)
      for (int i = 0; i < agentNum; i++) {
        float x = simData.getFloat(dataOffset);
        float y = simData.getFloat(dataOffset+4);

        dataOffset += 8;
        fill(0, 255, 0);
        circle(x, y, agentSize);
        /*if (walkers[i].inf) infected++;
         if (walkers[i].dead) dead++;
         if (walkers[i].immune) immune++;*/
      }
      frameNum++;
    } else {
      long now = millis();
      for (int i = 0; i < agentNum; i++) {
        if (state != SimStates.PAUSED) {
          if (walkers[i].state == AgentStates.INFECTED) infected++;
          if (walkers[i].state == AgentStates.DEAD) dead++;
          if (walkers[i].state == AgentStates.RECOVERED) immune++;

          if (gMovement) {
            walkers[i].stepGaussian(STD_DEV, MEAN);
          } else {
            walkers[i].stepFixed(fixedSpeed, maxAngleChange);
          }
          if (socialDistancingCheck.pressed) walkers[i].socialDistance(sDistance, sToughness/100, sReaction);
          walkers[i].outcome(deathProb/frameRate/100, recProb/frameRate/100);
          walkers[i].infect(infProb/frameRate/100);
          if (testingCheck.pressed) {
            if (walkers[i].state == AgentStates.INFECTED && !walkers[i].confined) {
              if ((now-startTime) - walkers[i].infTime > testDelay*1000) {
                if (random(1) <= testRelaiability) {
                  walkers[i].confined = true;
                  walkers[i].x = 100;
                  walkers[i].y = 620;
                }
              }
            }
          }
        }
        walkers[i].render();
      }
    }
  }

  void renderUI() {
    stroke(30);
    fill(62);
    rect(720, 0, 560, 720);
    fill(82);
    rect(730, 100, 540, 250);
    stroke(200);
    line (720, 45, 1280, 45);
    stroke(30);

    //Graphs background
    if (!graphsEngineCheck.pressed) {
      fill(255);
      rect (740, 380, 520, 320);
    } else {
      fill(80, 50, 50);
      rect (740, 380, 520, 320);

      fill(130, 90, 90);
      textSize(40);
      text("DISABLED", 899, 540);
    }

    //Simulation drawing

    start.render();

    stop.render();

    pause.render();

    walkerBtn.render();

    engineBtn.render();

    toolsBtn.render();

    if (!graphsEngineCheck.pressed) {
      infectedGraph.update(infected, agentNum);
      susceptibleGraph.update(agentNum-infected-dead-immune, agentNum);
      recoveredGraph.update(immune, agentNum);
      deadGraph.update(dead, agentNum);

      susceptibleGraph.render();
      infectedGraph.render();
      recoveredGraph.render();
      deadGraph.render();
    }

    frameRateShow();

    fill(255);
    textSize (20);
    text ("Epidemic simulator V2", 890, 30);

    textSize(16);

    text ("Susceptible:", 770, 125);

    text ("Infected:", 956, 125);

    text ("Total agents:", 1106, 125);

    if (renderEngineCheck.pressed) {
      text ("Length:", 764, 212);
      renderLenTB.render();
      textSize(18);
      if (state == SimStates.RUNNING) text("T: " + frameNum + "/" + renderLenTB.text + " f", 1140, 29);
    } else {
      if (state == SimStates.RUNNING) text("T: " + int((millis() - pauseTime - startTime)/1000) + " s", 1200, 29);
    }

    textSize (18);

    text ("Stop", 800, 82);

    if (state == SimStates.PAUSED) {
      text ("Unpause", 965, 82);
    } else {
      text ("Pause", 974, 82);
    }

    text ("Start", 1160, 82);

    text ("Agents", 790, 322);

    text ("Engine", 972, 322);

    text ("Tools", 1155, 322);

    textSize (15);
    text ("Gràfic susceptibles i infectats:", 750, 370);
    // Written info in console
    suceptibleNumTB.render();

    infectedNumTB.render();

    if (state == SimStates.PAUSED) {
      fill(0, 50);
      noStroke();
      rect(width/4.5, height/3.2, 40, 200);
      rect(width/3.5, height/3.2, 40, 200);
      stroke(30); // Restore stroke
    }

    if (state == SimStates.STOPPED) {
      infected = int(infectedNumTB.text);
      agentNum = int(suceptibleNumTB.text) + infected;
      renderLength = int(renderLenTB.text);
    } else {
      infectedNumTB.text = str(infected);
      suceptibleNumTB.text = str(agentNum - infected - immune - dead);
    }

    agentsNumTB.text = str(agentNum);
    agentsNumTB.render();

    if (testingCheck.pressed) {
      strokeWeight(4);
      fill(255, 255, 255, 0);
      rect(0, 520, 200, 200);
      strokeWeight(1);
    }

    engineWindow.render();
    agentsWindow.render();
    toolsWindow.render();

    if (engineWindow.open) {
      int x = engineWindow.x;
      int y = engineWindow.y;
      textSize(18);
      fill(255);
      text("Render Engine: ", x+20, y+60);
      text("Disable Graphs: ", x+20, y+98);

      renderEngineCheck.x = x + 240;
      renderEngineCheck.y = y + 44;

      graphsEngineCheck.x = x + 240;
      graphsEngineCheck.y = y + 82;

      renderEngineCheck.render();
      graphsEngineCheck.render();
    }

    if (toolsWindow.open) {
      int x = toolsWindow.x;
      int y = toolsWindow.y;
      textSize(18);
      fill(255);
      text("Social Distancing: ", x+20, y+60);
      text("Infection Testing: ", x+20, y+178);

      textSize(14);

      text("DIST", x+31, y+130);
      text("TGHS", x+126, y+130);
      text("RCTON", x+221, y+130);

      text("RLBTY", x+31, y+250);
      text("DELAY", x+126, y+250);

      socialDistancingCheck.x = x + 240;
      socialDistancingCheck.y = y + 44;

      distanceTB.x = x + 20;
      distanceTB.y = y + 80;

      toughnessTB.x = x + 115;
      toughnessTB.y = y + 80;

      reactionTB.x = x + 215;
      reactionTB.y = y + 80;

      testingCheck.x = x + 240;
      testingCheck.y = y + 162;

      testRelaiabilityTB.x = x + 20;
      testRelaiabilityTB.y = y + 200;

      testDelayTB.x = x + 115;
      testDelayTB.y = y + 200;

      if (socialDistancingCheck.pressed) {
        distanceTB.blocked = false;
        toughnessTB.blocked = false;
        reactionTB.blocked = false;
      } else {
        distanceTB.blocked = true;
        toughnessTB.blocked = true;
        reactionTB.blocked = true;
      }

      if (testingCheck.pressed) {
        testRelaiabilityTB.blocked = false;
        testDelayTB.blocked = false;
      } else {
        testRelaiabilityTB.blocked = true;
        testDelayTB.blocked = true;
      }

      distanceTB.render();
      toughnessTB.render();
      reactionTB.render();
      socialDistancingCheck.render();
      testingCheck.render();

      testRelaiabilityTB.render();
      testDelayTB.render();
      UpdateSimConfig();
    }

    if (agentsWindow.open) {
      int x = agentsWindow.x;
      int y = agentsWindow.y;
      textSize(18);
      fill(255);
      text("Agent size: ", x+20, y+62);

      text("Gaussian Movement: ", x+20, y+112);

      text("Fixed Movement: ", x+20, y+212);

      text("Agent globals: ", x+20, y+315);

      textSize(14);

      text("STD_DEV", x+21, y+140);
      text("MEAN", x+111, y+140);

      text("SPEED", x+28, y+240);
      text("ANGLE CHG", x+95, y+240);

      text("INFECT", x+28, y+380);
      text("DEATH", x+121, y+380);
      text("RECOVER", x+216, y+380);

      agentSizeTB.x = x + 210;
      agentSizeTB.y = y + 42;
      agentSizeTB.render();


      if (gaussianMovementCheck.pressed) {
        agentWalkSTD_DEV.blocked = false;
        agentWalkMEAN.blocked = false;

        agentWalkSPEED.blocked = true;
        agentWalkANGLECHG.blocked = true;
      } else {
        agentWalkSTD_DEV.blocked = true;
        agentWalkMEAN.blocked = true;

        agentWalkSPEED.blocked = false;
        agentWalkANGLECHG.blocked = false;
      }

      agentWalkSTD_DEV.x = x + 20;
      agentWalkSTD_DEV.y = y + 150;
      agentWalkSTD_DEV.render();

      agentWalkMEAN.x = x + 100;
      agentWalkMEAN.y = y + 150;
      agentWalkMEAN.render();

      agentWalkSPEED.x = x + 20;
      agentWalkSPEED.y = y + 250;
      agentWalkSPEED.render();

      agentWalkANGLECHG.x = x + 100;
      agentWalkANGLECHG.y = y + 250;
      agentWalkANGLECHG.render();

      switchCheck.x = x + 240;
      switchCheck.y = y + 195;
      switchCheck.render();

      gaussianMovementCheck.x = x + 240;
      gaussianMovementCheck.y = y + 96;
      gaussianMovementCheck.render();

      infChanceTB.x = x + 20;
      infChanceTB.y = y + 330;

      deathChanceTB.x = x + 115;
      deathChanceTB.y = y + 330;

      recChanceTB.x = x + 215;
      recChanceTB.y = y + 330;

      infChanceTB.render();
      deathChanceTB.render();
      recChanceTB.render();

      UpdateSimConfig();
    }
  }

  void start() {
    unfocusAllTexboxes(textBoxes);
    start.blocked = true;
    pause.blocked = false;
    stop.blocked = false;
    renderEngineCheck.blocked = true;
    this.setup();
  }

  void pause() {
    if (state == SimStates.RUNNING) {
      state = SimStates.PAUSED;
      pauseTimestamp = millis();
    } else if (state == SimStates.PAUSED) {
      pauseTime += millis() - pauseTimestamp;
      println(pauseTime);
      state = SimStates.RUNNING;
    }
  }

  void stop() {
    start.blocked = false;
    pause.blocked = true;
    stop.blocked = true;
    renderEngineCheck.blocked = false;
    infectedNumTB.text = str(initialInf);
    suceptibleNumTB.text = str(agentNum - initialInf);
    state = SimStates.STOPPED;
  }
}

class SimStates {
  static final int STOPPED = 0;
  static final int PAUSED = 1;
  static final int RUNNING = 2;
}

class AgentStates {
  static final int SUSCEPTIBLE = 0;
  static final int INFECTED = 1;
  static final int RECOVERED = 2;
  static final int DEAD = 3;
}

class Walker {
  int size;
  float x, y;
  // Possible agent states
  int state;
  float angle = random(360);
  long infTime = 0;
  boolean confined = false;
  boolean hide = false;
  Walker(float x, float y, int size, int state) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.state = state;
  }

  private void constrainPos() {
    if (!confined) {
      if (testingCheck.pressed) {
        if (x - size/2 < 200 && y + size/2 > 520) {
          hide = true;
        } else {
          hide = false;
        }
      }
      x = constrain(x, 0, 720-1);
      y = constrain(y, 0, height-1);
    } else {
      x = constrain(x, 0, 200);
      y = constrain(y, 520, height-1);
    }
  }

  // Makes a step in a random direction with a random amount of distance determined by a normal distribution
  void stepGaussian(int STD_DEV, int MEAN) {
    if (state == AgentStates.DEAD) return;

    float speed = (float) gen.nextGaussian();
    speed = (speed * STD_DEV) + MEAN;

    float r = (float) gen.nextGaussian();
    r = (r * STD_DEV) + MEAN;
    x += r * cos(random(2 * PI));
    y += r * sin(random(2 * PI));

    // Constrain agent position inside the screen.

    constrainPos();
  }

  void stepFixed(float speed, float angleChangeMax) {
    if (state == AgentStates.DEAD) return;

    float angleChg = angleChangeMax;

    x += speed * cos(radians(angle));
    y += speed * sin(radians(angle));

    if (x <= 0 || x >= 719 || y <= 0 || y >= width) {
      angleChg = angleChangeMax * 4; // Prevents from bumping into walls
    }

    angle += random(-angleChg, angleChg);

    constrainPos();
  }

  void socialDistance(float dist, float toughness, float reaction) {
    if (state != AgentStates.DEAD && state != AgentStates.RECOVERED && !confined) {
      noStroke();
      fill(255, 146, 64, 100);
      circle(x, y, dist*size);
      for (int i = 0; i < sim.agentNum; i++) {
        Walker other = sim.walkers[i];
        if (this != other) {
          if (other.state != AgentStates.DEAD && other.state != AgentStates.RECOVERED) {
            if (x + (size*dist)/2 > other.x - (other.size*dist)/2 && x - (size*dist)/2 < other.x + (other.size*dist)/2) {
              if (y + (size*dist)/2 > other.y - (other.size*dist)/2 && y - (size*dist)/2 < other.y + (other.size*dist)/2) {
                if (random(1) < toughness) {
                  if (x < other.x) {
                    x -= reaction;
                  } else {
                    x += reaction;
                  }

                  if (y < other.y) {
                    y -= reaction;
                  } else {
                    y += reaction;
                  }
                  if (random(1) > 0.5) {
                    angle += 90;
                  } else {
                    angle -= 90;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // Agent falls on two of the defined states when infected
  void outcome(float die, float recover) {
    if (state == AgentStates.INFECTED) {
      if (random(1) < die/frameRate) {
        state = AgentStates.DEAD;
      }
      if (random(1) < recover/frameRate) {
        state = AgentStates.RECOVERED;
      }
    }
  }

  // Checks if the infected agent is in contact with any other agent and handles the possibility of an infection spread
  void infect(float chance) {
    if (state == AgentStates.INFECTED && !confined) {
      for (int i = 0; i < sim.agentNum; i++) {
        Walker other = sim.walkers[i];
        if (this != other) {
          if (other.state != AgentStates.DEAD && other.state != AgentStates.RECOVERED) {
            if (x + size/2 > other.x - other.size/2 && x - size/2 < other.x + other.size/2) {
              if (y + size/2 > other.y - other.size/2 && y - size/2 < other.y + other.size/2) {
                if (random(1) < chance) {
                  sim.walkers[i].state = AgentStates.INFECTED;
                  sim.walkers[i].infTime = millis();
                }
              }
            }
          }
        }
      }
    }
  }

  // Renders the agent with different colors depending on state (red = infected, black = dead, blue = recovered, green = susceptible)
  void render() {
    noStroke();
    if (state == AgentStates.INFECTED) {
      fill(255, 0, 0);
    } else if (state == AgentStates.DEAD) {
      fill(0, 0, 0, 200);
    } else if (state == AgentStates.RECOVERED) {
      fill(0, 0, 255);
    } else {
      fill(0, 255, 0);
    }
    if (!hide) circle(x, y, size);
  }
}
