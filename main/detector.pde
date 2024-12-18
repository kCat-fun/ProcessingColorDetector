class Rectangle {
    private int x, y, w, h;

    Rectangle(int x, int y, int w, int h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    public void draw(PApplet applet) {
        applet.noFill();
        applet.stroke(0, 255, 0);
        applet.strokeWeight(2);
        applet.rect(x, y, w, h);
    }
}

class ColorDetector {
    private int width;
    private int height;
    private float hMin;
    private float hMax;
    private float sThreshold;
    private float vThreshold;

    /**
     * コンストラクタ
     * @param width  画像の幅
     * @param height 画像の高さ
     * @param hMin   検知する色のHの最小値
     * @param hMax   検知する色のHの最大値
     * @param sThreshold 彩度の閾値（0〜1）
     * @param vThreshold 明度の閾値（0〜1）
     */
    ColorDetector(int width, int height, float hMin, float hMax, float sThreshold, float vThreshold) {
        this.width = width;
        this.height = height;
        this.hMin = hMin;
        this.hMax = hMax;
        this.sThreshold = sThreshold;
        this.vThreshold = vThreshold;
    }

    /**
     * 指定されたHの範囲内にある色を検知し、矩形を描画
     */
    public Rectangle detectAndDrawColor(PApplet applet, Capture cam) {
        int minX = width, maxX = 0, minY = height, maxY = 0;

        cam.loadPixels();
        for (int y = 0; y < cam.height; y++) {
            for (int x = 0; x < cam.width; x++) {
                int loc = x + y * cam.width;
                int c = cam.pixels[loc];

                // RGBをHSVに変換
                float r = applet.red(c);
                float g = applet.green(c);
                float b = applet.blue(c);
                float[] hsv = rgbToHsv(r, g, b);

                // 指定のH範囲内の色を検出
                if (isColorInRange(hsv)) {
                    if (x < minX) minX = x;
                    if (x > maxX) maxX = x;
                    if (y < minY) minY = y;
                    if (y > maxY) maxY = y;
                }
            }
        }

        // 指定色の領域を矩形で囲む
        if (minX < maxX && minY < maxY) {
            Rectangle rect = new Rectangle(width - minX - (maxX - minX), minY, maxX - minX, maxY - minY);
            rect.draw(applet);
            return rect;
        }

        return null;
    }

    /**
     * 指定されたHSV値が範囲内にあるかどうかを判定
     */
    private boolean isColorInRange(float[] hsv) {
        float h = hsv[0];
        float s = hsv[1];
        float v = hsv[2];

        boolean isHInRange = (h >= hMin && h <= hMax);
        if (hMax < hMin) { // Hの範囲が循環している場合
            isHInRange = (h >= hMin || h <= hMax);
        }

        return isHInRange && s > sThreshold && v > vThreshold;
    }

    /**
     * RGB値をHSVに変換する関数
     */
    private float[] rgbToHsv(float r, float g, float b) {
        r /= 255.0;
        g /= 255.0;
        b /= 255.0;
        float max = Math.max(r, Math.max(g, b));
        float min = Math.min(r, Math.min(g, b));
        float h = 0, s, v = max;

        float d = max - min;
        s = max == 0 ? 0 : d / max;

        if (max == min) {
            h = 0; // グレー
        } else {
            if (max == r) {
                h = (g - b) / d + (g < b ? 6 : 0);
            } else if (max == g) {
                h = (b - r) / d + 2;
            } else if (max == b) {
                h = (r - g) / d + 4;
            }
            h /= 6;
        }

        h *= 360; // 角度に変換
        return new float[]{h, s, v};
    }
}
