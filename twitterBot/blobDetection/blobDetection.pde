// - Super Fast Blur v1.1 by Mario Klingemann <http://incubator.quasimondo.com>
import processing.video.*;
import blobDetection.*;
import codeanticode.syphon.*;
import java.awt.*;

SyphonClient client;
Capture cam;
BlobDetection theBlobDetection;
PImage img;

void settings() {
size(480, 340, P3D);
PJOGL.profile = 1;
}

void setup(){
  size(640, 478);
  client = new SyphonClient(this);
  theBlobDetection = new BlobDetection(640, 478);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.6f); // will detect bright areas whose luminosity > 0.2f;
}

void draw(){
  if (client.newFrame()){
    img = client.getImage(img);
    theBlobDetection.computeBlobs(img.pixels);
    drawBlobsAndEdges(true,true);
  }
  if (img != null) {
    image(img, 0, 0, width, height);
    theBlobDetection.computeBlobs(img.pixels);
    drawBlobsAndEdges(true,true);
  }
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges){
  noFill();
  Blob b;
  EdgeVertex eA,eB;
  float radius = 5;
  float maxRectArea = -1;
  float minRectArea = 1000000;
  float maxRectminX = 0; float maxRectminY = 0; float maxRectmaxX = 0; float maxRectmaxY = 0;
  float minRectminX = 0; float minRectminY = 0; float minRectmaxX = 0; float minRectmaxY = 0;
  Blob [] blobArray = new Blob[2];
  if (theBlobDetection.getBlobNb()>0){
    blobArray[0] = theBlobDetection.getBlob(0);
  }
  for (int n=1 ; n<theBlobDetection.getBlobNb() ; n++){
    Blob d=theBlobDetection.getBlob(n);
    Blob og=theBlobDetection.getBlob(0);
    if (abs(d.xMin-og.xMin)>radius){
      blobArray[1] = d;
    }
  }
  
  for (int n=0 ; n<blobArray.length; n++){
    b=blobArray[n];
    //b = theBlobDetection.getBlob(n);
    if (b!=null){
      if (drawEdges){
        strokeWeight(3);
        stroke(0,255,0);
        for (int m=0;m<b.getEdgeNb();m++){
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null){
            line(
             eA.x*width, eA.y*height, 
             eB.x*width, eB.y*height);
          }
        }
      }
      if (drawBlobs){
        strokeWeight(1);
        stroke(255,0,0);
        rect(
         b.xMin*width-radius/2,b.yMin*height-radius/2,
         b.w*width+radius/2,b.h*height+radius/2);
      }
    }
  }
  //fill(100,0,0);
  //ellipse((maxRectminX+maxRectmaxX)/2, (maxRectminY+maxRectmaxY)/2,20,10); 
  //fill(0,100,0);
  //ellipse((minRectminX+minRectmaxX)/2, (minRectminY+minRectmaxY)/2,10,10); 
}