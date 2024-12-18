class CheckArea {
    private int x; // 矩形の左上のX座標
    private int y; // 矩形の左上のY座標
    private int w; // 矩形の幅
    private int h; // 矩形の高さ

    // コンストラクタ
    CheckArea(int x, int y, int w, int h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    /**
     * 指定された点がこのエリア内にあるかどうかを判定
     * @param _x 判定する点のX座標
     * @param _y 判定する点のY座標
     * @return エリア内にある場合はtrue、それ以外はfalse
     */
    public boolean isOverlapArea(int _x, int _y) {
        return (_x >= x && _x <= x + w && _y >= y && _y <= y + h);
    }

    /**
     * このエリアを薄い青色で描画
     * @param applet PAppletのインスタンス（Processingの描画機能を利用するため）
     */
    public void drawCheckArea(PApplet applet) {
        applet.noStroke();
        applet.fill(173, 216, 230, 128); // 薄い青色 (R:173, G:216, B:230, 透明度:128)
        applet.rect(x, y, w, h);
    }
}
