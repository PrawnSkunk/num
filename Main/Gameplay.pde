class Gameplay extends Screen {
  
  int count;

  Gameplay() {
  }

  void screenSetup() {
    super.screenSetup();
    arrowAL = new ArrayList<Arrow>();
    receptorAL = new ArrayList<Receptor>();
    transmitterAL = new ArrayList<Transmitter>();
    grid = new PVector[]{ new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, -1), new PVector(-1, 1), new PVector(1, -1), new PVector(1, 1) };
    keys = new char[]{ '4', '2', '8', '6', '7', '1', '9', '3' };
    rotations = new int[]{2, 0, 4, 6, 3, 1, 5, 7};
    pressed = new boolean[keys.length];
    sm = new Parse();
    parse();
    gridSetup();
    loadAudio();
    timeSinceLastStateSwitch = float(millis());
  }

  void HUD() {
    float maxWidth = width-height;
    fill(75);
    rect(0, 0, maxWidth/2.2+1, height);
    rect(width-maxWidth/2.2-1, 0, maxWidth/2.2, height);
    fill(15);
    rect(0, 0, maxWidth/2.2, height);
    rect(width-maxWidth/2.2, 0, maxWidth/2.2, height);
  }

  // Execute note data to spawn note at respective transmitter
  void spawnNotes() {

    // for the length of the array (sm.notes = [8][1.1248313][3.0])
    for (int i=count; i<sm.notes.length; i++) {
      
      if (sm.notes[i].length > 0 && sm.notes[i][0] > 0) {

        index = (int)sm.notes[i][1];
        float[] gridArr = grid[index].array();

        if (time - sm.notes[i][0]*1000 < 0 && time - sm.notes[i][0]*1000 > -1000) {  
          //println((float(millis())-timeSinceLastStateSwitch)+(sm.offset*1000));
          arrowAL.add(new Arrow(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8, -gridArr[0]*speedmod, -gridArr[1]*speedmod, rotations[index]));
          sm.notes[i][0] = 0; 
          count++;
        }
      }
    }
  }
  void screenDraw() {
    super.screenDraw();
    time = getTime();
    background(0);
    spawnNotes();
    drawObjects();
    HUD();
  }

  // Load and play audio
  void loadAudio() {
    minim.stop();
    song = minim.loadFile("/songs/"+songname+"/"+songname+".mp3");
    //trackLength = song.length();
    song.rewind();
    song.play();
  }

  // Instantiate stationary objects
  void gridSetup() {
    for (int i = 0; i < grid.length; i++) {
      float[] gridArr = grid[i].array();
      receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius, rotations[i]));
      transmitterAL.add(new Transmitter(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8));
    }
  }
}