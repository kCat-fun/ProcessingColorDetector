class Camera {
    private Capture cam;

    Camera(PApplet applet) {
        String[] cameras = Capture.list();
        if (cameras.length == 0) {
            applet.println("No cameras available.");
            applet.exit();
        } else {
            applet.println("Available cameras:");
            for (int i = 0; i < cameras.length; i++) {
                applet.println(i + ": " + cameras[i]);
            }
            cam = new Capture(applet, cameras[0]);
            cam.start();
        }
    }

    public Capture getCameraImage(PApplet applet) {
        if (cam.available()) {
            cam.read();
        }
        return cam;
    }

    public void reverseImage(PApplet applet, Capture cam) {
        applet.pushMatrix();
        applet.translate(applet.width, 0);
        applet.scale(-1, 1); // 水平方向を反転
        applet.image(cam, 0, 0);
        applet.popMatrix();
    }
}
