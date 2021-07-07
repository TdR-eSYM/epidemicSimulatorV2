class Simulation {
  int state;
  Walker[] walkers;
  int agentNum, agentSize;
  float startInfProb;

  Simulation(int agentNum, int agentSize, float startInfProb) {
    this.agentNum = agentNum;
    this.agentSize = agentSize;
    this.startInfProb = startInfProb;
    state = SimStates.STOPPED;
  }

  void setup() {
    walkers = new Walker[agentNum];
    for (int i = 0; i < agentNum; i++) {
      boolean inf = false;
      float xPos = random(0, 720);
      float yPos = random(0, height);

      if (random(1) < startInfProb) {
        inf = true;
      }
      walkers[i] = new Walker(xPos, yPos, agentSize, inf);
    }
  }

  void tick() {
    if(state == SimStates.STOPPED) return;
    for (int i = 0; i < agentNum; i++) {
      if (state != SimStates.PAUSED) {
        walkers[i].step();
        walkers[i].outcome(0.01, 0.001);
        walkers[i].infect(1/frameRate);
      }
      walkers[i].render();
    }
  }

  void start() {
    state = SimStates.RUNNING;
  }

  void pause() {
    state = SimStates.PAUSED;
  }

  void stop() {
    state = SimStates.STOPPED;
  }
}

class SimStates {
  static final int STOPPED = 0;
  static final int PAUSED = 1;
  static final int RUNNING = 2;
}

class Walker {
  int size;
  float x, y;

  // Possible agent states
  boolean inf, dead, immune;

  Walker(float x, float y, int size, boolean infec) {
    this.x = x;
    this.y = y;
    this.size = size;
    inf = infec;
    dead = false;
    immune = false;
  }

  // Makes a step in a random direction with a random amount of distance determined by a normal distribution
  void step() {
    if (dead) return;

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
    if (inf) {
      if (random(1) < die/frameRate) {
        dead = true;
        inf = false;
      }
      if (random(1) < recover/frameRate) {
        immune = true;
        inf = false;
      }
    }
  }

  // Checks if the infected agent is in contact with any other agent and handles the possibility of an infection spread
  void infect(float chance) {
    if (inf) {
      for (int i = 0; i < sim.agentNum; i++) {
        Walker other = sim.walkers[i];
        if (!other.dead && !other.immune) {
          if (x + size/2 > other.x - other.size/2 && x - size/2 < other.x + other.size/2) {
            if (y + size/2 > other.y - other.size/2 && y - size/2 < other.y + other.size/2) {
              if (random(1) < chance) {
                sim.walkers[i].inf = true;
              }
            }
          }
        }
      }
    }
  }

  // Renders the agent with different colors depending on state (red = infected, black = dead, blue = recovered, green = susceptible)
  void render() {
    if (inf) {
      fill(255, 0, 0);
    } else if (dead) {
      fill(0);
    } else if (immune) {
      fill(0, 0, 255);
    } else {
      fill(0, 255, 0);
    }
    circle(x, y, size);
  }
}
