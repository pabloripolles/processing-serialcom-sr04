/// SerialComASCIISR04

/** This allows to read data from Arduino and send it to Processing using ASCII
  * based serial communication.
  *
  * Pablo Ripolles @ Birmingham, 2015-09-30
  */

import processing.serial.Serial;

import grafica.*;

Serial port = null;

int nPoints = 0;
GPointsArray points = null;
GPlot plot = null;

int r = 0;
int d = 0;

int t = 0;
int tau = 0;

void setup() {
  size(500, 350);
  background(150);

  //println(Serial.list());
  port = new Serial(this, Serial.list()[2], 115200);
  // Read bytes into a buffer until you get a newline:
  port.bufferUntil('\n');

  // Prepare the points for the plot.
  nPoints = 100;
  points = new GPointsArray(nPoints);

  r = nPoints;
  d = 0;

  t = millis();
  tau = 100;

  for (int i = 0; i < nPoints; i++) {
    points.add(i, 0);
  }

  // Create a new plot and set its position on the screen.
  plot = new GPlot(this, 25, 25);

  // Set the plot title and the axis labels.
  plot.setTitleText("HC-SR04 distance sensor");
  plot.getXAxis().setAxisLabelText("reading axis");
  plot.getYAxis().setAxisLabelText("distance axis (cm)");

  // Add the points.
  plot.setPoints(points);

  // Draw it!
  plot.defaultDraw();
}

void draw() {
  if (millis() - t > tau) {
    r = r + 1;

    t = millis();

    points.remove(0);
    points.add(r, d);

    plot.setPoints(points);

    plot.defaultDraw();
  }
}

/** serialEvent() method is run automatically by the Processing applet
  * whenever the buffer reaches the byte value set in the
  * bufferUntil() method in the setup().
  */
void serialEvent(Serial port) {
  // Read the buffer from the serial port:
  String inString = port.readString();

  inString = trim(inString);
  if (inString != null) {
    int inData[] = int(split(inString, ' '));

    if (inData[0] != 0) {
      d = inData[0];
    }
  }

  // Send a ! to request new data.
  port.write('!');
}