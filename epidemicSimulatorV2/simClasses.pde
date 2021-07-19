class Simulation {
  int state;
  Walker[] walkers;
  int agentNum, agentSize, infected, dead, immune, initialInf;
  float startInfProb;

  Simulation(int agentNum, int agentSize, int initialInf) {
    this.agentNum = agentNum;
    this.agentSize = agentSize;
    this.initialInf = initialInf;
    state = SimStates.STOPPED;
  }

  void setup() {
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
    initialInf = infected;
    state = SimStates.RUNNING;
  }

  void tick() {
    if (state == SimStates.STOPPED) return;
    if (state == SimStates.RUNNING) {
      infected = 0;
      dead = 0;
      immune = 0;
    }
    for (int i = 0; i < agentNum; i++) {
      if (state != SimStates.PAUSED) {
        if (walkers[i].state == AgentStates.INFECTED) infected++;
        if (walkers[i].state == AgentStates.DEAD) dead++;
        if (walkers[i].state == AgentStates.RECOVERED) immune++;

        walkers[i].step();
        walkers[i].outcome(0.01, 0.001);
        walkers[i].infect(1/frameRate);
      }
      walkers[i].render();
    }
  }

  void start() {
    if(state != SimStates.STOPPED) return;
    unfocusAllTexboxes(textBoxes);
    this.setup();
  }

  void pause() {
    if(state == SimStates.RUNNING){
      state = SimStates.PAUSED;
    } else if (state == SimStates.PAUSED){
      state = SimStates.RUNNING;
    }
  }

  void stop() {
    if(state == SimStates.STOPPED) return; // Prevent "stopping" if the simulation is already stopped
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

  Walker(float x, float y, int size, int state) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.state = state;
  }

  // Makes a step in a random direction with a random amount of distance determined by a normal distribution
  void step() {
    if (state == AgentStates.DEAD) return;

    float speed = (float) gen.nextGaussian();
    speed = (speed * STD_DEV) + MEAN;

    float r = (float) gen.nextGaussian();
    r = (r * STD_DEV) + MEAN;
    x += r * cos(random(2 * PI));
    y += r * sin(random(2 * PI));

    // Constrain agent position inside the screen.
    x = constrain(x, 0, 720-1);
    y = constrain(y, 0, height-1);
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
    if (state == AgentStates.INFECTED) {
      for (int i = 0; i < sim.agentNum; i++) {
        Walker other = sim.walkers[i];
        if (other.state != AgentStates.DEAD && other.state != AgentStates.RECOVERED) {
          if (x + size/2 > other.x - other.size/2 && x - size/2 < other.x + other.size/2) {
            if (y + size/2 > other.y - other.size/2 && y - size/2 < other.y + other.size/2) {
              if (random(1) < chance) {
                sim.walkers[i].state = AgentStates.INFECTED;
              }
            }
          }
        }
      }
    }
  }

  // Renders the agent with different colors depending on state (red = infected, black = dead, blue = recovered, green = susceptible)
  void render() {
    stroke(50);
    if (state == AgentStates.INFECTED) {
      fill(255, 0, 0);
    } else if (state == AgentStates.DEAD) {
      fill(0);
    } else if (state == AgentStates.RECOVERED) {
      fill(0, 0, 255);
    } else {
      fill(0, 255, 0);
    }
    circle(x, y, size);
  }
}
