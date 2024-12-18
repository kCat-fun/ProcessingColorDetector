import processing.video.*;

ColorDetector detector;
Camera camera;
CheckArea[] checkAreas;

void setup() {
    size(640, 480);
    camera = new Camera(this);

    // 検出した物体が特定の座標内にいることを検出するエリアの設定
    checkAreas = new CheckArea[] {
        new CheckArea(100, 120, 200, 150),
        new CheckArea(400, 320, 50, 50),
    };

    // 検出範囲を設定（ [例] 赤色: H=350〜10, 彩度0.6以上, 明度0.6以上）
    detector = new ColorDetector(width, height, 350, 10, 0.6, 0.6);
}

void draw() {
    Capture cam = camera.getCameraImage(this);

    // カメラ映像を描画
    camera.reverseImage(this, cam);

    // 検出エリアを青く塗る
    for (CheckArea checkArea : checkAreas) {
        checkArea.drawCheckArea(this);
    }

    push();
    fill(0);
    rect(width - 40, 0, 40, 40);
    pop();

    // 指定範囲の色を検出して描画
    Rectangle rect = detector.detectAndDrawColor(this, cam);
    if (rect != null) {
        final float centerX = rect.x + (rect.w/2.0);
        final float centerY = rect.y + (rect.h/2.0);

        println("(x, y) = (" + centerX + ", " + centerY + ")");
        push();
        fill(0, 255, 0);
        circle(centerX, centerY, 5);
        pop();

        int checkAreaNumber = 0;
        // 検出エリア内に物体が存在するかを識別する
        for (CheckArea checkArea : checkAreas) {
            final boolean isInside = checkArea.isOverlapArea(int(centerX), int(centerY));
            if (isInside) {
                break;
            }
            checkAreaNumber++;
        }

        push();
        textAlign(RIGHT, TOP);
        fill(255);
        textSize(30);

        if (checkAreaNumber < checkAreas.length) {
            text(checkAreaNumber, width - 10, 10);
        } else {
            text("-", width - 10, 10);
        }

        pop();
    }
}
