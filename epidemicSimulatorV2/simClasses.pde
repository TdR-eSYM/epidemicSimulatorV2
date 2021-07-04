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
      for (int i = 0; i < walkers.length; i++) {
        Walker other = walkers[i];
        if (!other.dead && !other.immune) {
          if (x + size/2 > other.x - other.size/2 && x - size/2 < other.x + other.size/2) {
            if (y + size/2 > other.y - other.size/2 && y - size/2 < other.y + other.size/2) {
              if (random(1) < chance) {
                walkers[i].inf = true;
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
