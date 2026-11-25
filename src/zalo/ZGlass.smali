.class public final Lcom/zing/zalo/zsplit/ZGlass;
.super Landroid/graphics/drawable/Drawable;

.field public host:Landroid/view/View;
.field public pager:Landroid/view/View;
.field public cur:F
.field public drag:F
.field public vel:F
.field public hold:F
.field public holdT:J
.field public paint:Landroid/graphics/Paint;
.field public rect:Landroid/graphics/RectF;
.field public lens:Z
.field public lensA:F
.field public path:Landroid/graphics/Path;
.field public node:Landroid/graphics/RenderNode;
.field public rs:Landroid/graphics/RuntimeShader;
.field static sAct:I

.method public constructor <init>(Landroid/view/View;Landroid/view/View;)V
    .locals 2
    invoke-direct {p0}, Landroid/graphics/drawable/Drawable;-><init>()V
    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    iput-object p2, p0, Lcom/zing/zalo/zsplit/ZGlass;->pager:Landroid/view/View;
    const/high16 v0, 0x7fc00000
    iput v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    iput v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->drag:F
    iput v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->hold:F
    new-instance v0, Landroid/graphics/Paint;
    const/4 v1, 0x1
    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V
    iput-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->paint:Landroid/graphics/Paint;
    new-instance v0, Landroid/graphics/RectF;
    invoke-direct {v0}, Landroid/graphics/RectF;-><init>()V
    iput-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->rect:Landroid/graphics/RectF;
    return-void
.end method

.method public getOpacity()I
    .locals 1
    const/4 v0, -0x3
    return v0
.end method

.method public setAlpha(I)V
    .locals 0
    return-void
.end method

.method public setColorFilter(Landroid/graphics/ColorFilter;)V
    .locals 0
    return-void
.end method

.method public tabs()Landroid/view/ViewGroup;
    .locals 4
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    instance-of v1, v0, Landroid/view/ViewGroup;
    if-eqz v1, :n
    check-cast v0, Landroid/view/ViewGroup;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    :l
    add-int/lit8 v1, v1, -0x1
    if-ltz v1, :n
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v2
    instance-of v3, v2, Landroid/widget/LinearLayout;
    if-eqz v3, :l
    check-cast v2, Landroid/view/ViewGroup;
    return-object v2
    :n
    const/4 v0, 0x0
    return-object v0
.end method

.method public static count(Landroid/view/ViewGroup;)I
    .locals 5
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    const/4 v1, 0x0
    const/4 v2, 0x0
    :l
    if-ge v1, v0, :e
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I
    move-result v4
    if-nez v4, :s
    add-int/lit8 v2, v2, 0x1
    :s
    add-int/lit8 v1, v1, 0x1
    goto :l
    :e
    return v2
.end method

.method public static kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    .locals 5
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    const/4 v1, 0x0
    const/4 v2, 0x0
    :l
    if-ge v1, v0, :e
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I
    move-result v4
    if-nez v4, :s
    if-ne v2, p1, :inc
    return-object v3
    :inc
    add-int/lit8 v2, v2, 0x1
    :s
    add-int/lit8 v1, v1, 0x1
    goto :l
    :e
    const/4 v3, 0x0
    return-object v3
.end method

.method public static cx(Landroid/view/ViewGroup;Landroid/view/View;)F
    .locals 2
    invoke-virtual {p0}, Landroid/view/View;->getLeft()I
    move-result v0
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I
    move-result v1
    add-int/2addr v0, v1
    int-to-float v0, v0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I
    move-result v1
    int-to-float v1, v1
    const/high16 p0, 0x40000000
    div-float/2addr v1, p0
    add-float/2addr v0, v1
    return v0
.end method

.method public posFromX(F)F
    .locals 8
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v0
    const/4 v7, 0x0
    if-nez v0, :ok
    return v7
    :ok
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZGlass;->count(Landroid/view/ViewGroup;)I
    move-result v1
    const/4 v2, 0x0
    :l
    add-int/lit8 v3, v1, -0x1
    if-ge v2, v3, :last
    invoke-static {v0, v2}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->cx(Landroid/view/ViewGroup;Landroid/view/View;)F
    move-result v4
    add-int/lit8 v3, v2, 0x1
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->cx(Landroid/view/ViewGroup;Landroid/view/View;)F
    move-result v5
    cmpg-float v6, p1, v5
    if-lez v6, :in
    add-int/lit8 v2, v2, 0x1
    goto :l
    :in
    sub-float v6, p1, v4
    sub-float v5, v5, v4
    div-float/2addr v6, v5
    cmpg-float v5, v6, v7
    if-gez v5, :p
    move v6, v7
    :p
    int-to-float v5, v2
    add-float/2addr v6, v5
    return v6
    :last
    if-gez v3, :lp
    const/4 v3, 0x0
    :lp
    int-to-float v3, v3
    return v3
.end method

.method public pagerPos()F
    .locals 8
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v0
    if-eqz v0, :n
    sget v1, Lcom/zing/zalo/zsplit/ZGlass;->sAct:I
    if-nez v1, :hid
    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v1
    const-string v2, "iconActive"
    const-string v3, "id"
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v4
    invoke-virtual {v4}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v1, v2, v3, v4}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v1
    sput v1, Lcom/zing/zalo/zsplit/ZGlass;->sAct:I
    if-eqz v1, :n
    :hid
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZGlass;->count(Landroid/view/ViewGroup;)I
    move-result v2
    const/4 v3, 0x0
    :l
    if-ge v3, v2, :n
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :nx
    invoke-virtual {v4, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v5
    if-eqz v5, :nx
    invoke-virtual {v5}, Landroid/view/View;->getVisibility()I
    move-result v5
    if-nez v5, :nx
    int-to-float v3, v3
    return v3
    :nx
    add-int/lit8 v3, v3, 0x1
    goto :l
    :n
    const/high16 v0, 0x7fc00000
    return v0
.end method

.method public tick0()V
    .locals 9
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->pagerPos()F
    move-result v0
    iget v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->hold:F
    invoke-static {v1}, Ljava/lang/Float;->isNaN(F)Z
    move-result v2
    if-nez v2, :nohold
    cmpl-float v2, v0, v1
    if-eqz v2, :rel
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v2
    iget-wide v4, p0, Lcom/zing/zalo/zsplit/ZGlass;->holdT:J
    cmp-long v2, v2, v4
    if-gtz v2, :rel
    move v0, v1
    goto :nohold
    :rel
    const/high16 v2, 0x7fc00000
    iput v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->hold:F
    :nohold
    iget v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    iget v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->drag:F
    invoke-static {v2}, Ljava/lang/Float;->isNaN(F)Z
    move-result v3
    if-nez v3, :nodrag
    const/4 v4, 0x0
    invoke-static {v1}, Ljava/lang/Float;->isNaN(F)Z
    move-result v3
    if-nez v3, :d0
    sub-float v4, v2, v1
    :d0
    iput v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    iput v4, p0, Lcom/zing/zalo/zsplit/ZGlass;->vel:F
    const/4 v3, 0x1
    iput-boolean v3, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    goto :inv
    :nodrag
    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z
    move-result v3
    if-eqz v3, :ht
    return-void
    :ht
    invoke-static {v1}, Ljava/lang/Float;->isNaN(F)Z
    move-result v3
    if-eqz v3, :spring
    iput v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    const/4 v3, 0x0
    iput v3, p0, Lcom/zing/zalo/zsplit/ZGlass;->vel:F
    iput-boolean v3, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    goto :inv
    :spring
    iget v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->vel:F
    const v3, 0x3f466666
    mul-float v4, v2, v3
    sub-float v5, v0, v1
    const v3, 0x3cf5c28f
    mul-float/2addr v5, v3
    add-float/2addr v4, v5
    add-float v5, v1, v4
    sub-float v6, v0, v5
    invoke-static {v6}, Ljava/lang/Math;->abs(F)F
    move-result v6
    invoke-static {v4}, Ljava/lang/Math;->abs(F)F
    move-result v7
    const v3, 0x3b03126f
    cmpg-float v8, v6, v3
    if-gez v8, :moving
    cmpg-float v8, v7, v3
    if-gez v8, :moving
    move v5, v0
    const/4 v4, 0x0
    cmpl-float v8, v5, v1
    if-nez v8, :moving
    const/4 v8, 0x0
    cmpl-float v8, v2, v8
    if-nez v8, :moving
    iget-boolean v8, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    if-nez v8, :off
    return-void
    :off
    const/4 v8, 0x0
    iput-boolean v8, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    goto :inv
    :moving
    iput v5, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    iput v4, p0, Lcom/zing/zalo/zsplit/ZGlass;->vel:F
    iget v6, p0, Lcom/zing/zalo/zsplit/ZGlass;->hold:F
    invoke-static {v6}, Ljava/lang/Float;->isNaN(F)Z
    move-result v6
    xor-int/lit8 v8, v6, 0x1
    iput-boolean v8, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    :inv
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->invalidate()V
    return-void
.end method

.method public draw(Landroid/graphics/Canvas;)V
    .locals 4
    :try_start
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v1
    iget v1, v1, Landroid/util/DisplayMetrics;->density:F
    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v0
    iget v0, v0, Landroid/content/res/Configuration;->uiMode:I
    and-int/lit8 v0, v0, 0x30
    const/16 v2, 0x20
    const/4 v3, 0x0
    if-ne v0, v2, :l
    const/4 v3, 0x1
    :l
    invoke-virtual {p0, p1, v3, v1}, Lcom/zing/zalo/zsplit/ZGlass;->bar(Landroid/graphics/Canvas;ZF)V
    invoke-virtual {p0, p1, v3, v1}, Lcom/zing/zalo/zsplit/ZGlass;->drop(Landroid/graphics/Canvas;ZF)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :e
    :e
    return-void
.end method

.method public bar(Landroid/graphics/Canvas;ZF)V
    .locals 8
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;
    move-result-object v0
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I
    move-result v1
    int-to-float v1, v1
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I
    move-result v2
    int-to-float v2, v2
    iget-object v3, p0, Lcom/zing/zalo/zsplit/ZGlass;->paint:Landroid/graphics/Paint;
    iget-object v4, p0, Lcom/zing/zalo/zsplit/ZGlass;->rect:Landroid/graphics/RectF;
    const/4 v0, 0x0
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;
    invoke-virtual {v3}, Landroid/graphics/Paint;->clearShadowLayer()V
    sget-object v0, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    const v0, -0x19000001
    if-eqz p2, :c1
    const v0, -0x26dfdfde
    :c1
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setColor(I)V
    const/4 v0, 0x0
    invoke-virtual {v4, v0, v0, v1, v2}, Landroid/graphics/RectF;->set(FFFF)V
    const/high16 v0, 0x40000000
    div-float v5, v2, v0
    invoke-virtual {p1, v4, v5, v5, v3}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    sget-object v0, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    invoke-virtual {v3, p3}, Landroid/graphics/Paint;->setStrokeWidth(F)V
    const v0, -0x4c000001
    if-eqz p2, :c2
    const v0, 0x33ffffff
    :c2
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setColor(I)V
    const/high16 v0, 0x40000000
    div-float v6, p3, v0
    invoke-virtual {v4, v6, v6}, Landroid/graphics/RectF;->inset(FF)V
    invoke-virtual {p1, v4, v5, v5, v3}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    sget-object v0, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v3, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    return-void
.end method

.method public drop(Landroid/graphics/Canvas;ZF)V
    .locals 0
    return-void
.end method

.method public static grad(Landroid/graphics/Paint;FFII)V
    .locals 8
    new-instance v0, Landroid/graphics/LinearGradient;
    const/4 v1, 0x0
    move v2, p1
    const/4 v3, 0x0
    move v4, p2
    move v5, p3
    move v6, p4
    sget-object v7, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;
    invoke-direct/range {v0 .. v7}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V
    invoke-virtual {p0, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;
    return-void
.end method

.method public tick()V
    .locals 4
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tick0()V
    iget-boolean v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    const/4 v1, 0x0
    if-eqz v0, :t
    const/high16 v1, 0x3f800000
    :t
    iget v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    sub-float v3, v1, v2
    invoke-static {v3}, Ljava/lang/Math;->abs(F)F
    move-result v0
    const v1, 0x3c23d70a
    cmpg-float v0, v0, v1
    if-gez v0, :anim
    iget v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    iget-boolean v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->lens:Z
    const/4 v2, 0x0
    if-eqz v0, :z
    const/high16 v2, 0x3f800000
    :z
    cmpl-float v0, v1, v2
    if-eqz v0, :e
    iput v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    goto :inv
    :anim
    const v0, 0x3e0f5c29
    mul-float/2addr v3, v0
    add-float/2addr v2, v3
    iput v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    :inv
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {v0}, Landroid/view/View;->invalidate()V
    :e
    return-void
.end method

.method public geom(F)F
    .locals 13
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v0
    const/high16 v12, -0x40800000
    if-nez v0, :a
    return v12
    :a
    invoke-static {v0}, Lcom/zing/zalo/zsplit/ZGlass;->count(Landroid/view/ViewGroup;)I
    move-result v1
    if-gtz v1, :b
    return v12
    :b
    iget v2, p0, Lcom/zing/zalo/zsplit/ZGlass;->cur:F
    invoke-static {v2}, Ljava/lang/Float;->isNaN(F)Z
    move-result v3
    if-eqz v3, :c
    return v12
    :c
    const/4 v3, 0x0
    invoke-static {v2, v3}, Ljava/lang/Math;->max(FF)F
    move-result v2
    add-int/lit8 v3, v1, -0x1
    int-to-float v3, v3
    invoke-static {v2, v3}, Ljava/lang/Math;->min(FF)F
    move-result v2
    float-to-int v3, v2
    add-int/lit8 v4, v1, -0x2
    if-le v3, v4, :d1
    move v3, v4
    :d1
    if-gez v3, :d2
    const/4 v3, 0x0
    :d2
    int-to-float v4, v3
    sub-float v4, v2, v4
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v5
    add-int/lit8 v3, v3, 0x1
    add-int/lit8 v1, v1, -0x1
    invoke-static {v3, v1}, Ljava/lang/Math;->min(II)I
    move-result v3
    invoke-static {v0, v3}, Lcom/zing/zalo/zsplit/ZGlass;->kid(Landroid/view/ViewGroup;I)Landroid/view/View;
    move-result-object v6
    if-eqz v5, :x
    if-nez v6, :e
    :x
    return v12
    :e
    invoke-static {v0, v5}, Lcom/zing/zalo/zsplit/ZGlass;->cx(Landroid/view/ViewGroup;Landroid/view/View;)F
    move-result v7
    invoke-static {v0, v6}, Lcom/zing/zalo/zsplit/ZGlass;->cx(Landroid/view/ViewGroup;Landroid/view/View;)F
    move-result v8
    sub-float/2addr v8, v7
    mul-float/2addr v8, v4
    add-float/2addr v7, v8
    invoke-virtual {v5}, Landroid/view/View;->getWidth()I
    move-result v8
    int-to-float v8, v8
    invoke-virtual {v6}, Landroid/view/View;->getWidth()I
    move-result v9
    int-to-float v9, v9
    sub-float/2addr v9, v8
    mul-float/2addr v9, v4
    add-float/2addr v8, v9
    # v7 center, v8 cell width; stretch s -> v9
    iget v9, p0, Lcom/zing/zalo/zsplit/ZGlass;->vel:F
    invoke-static {v9}, Ljava/lang/Math;->abs(F)F
    move-result v9
    const/high16 v10, 0x40c00000
    mul-float/2addr v9, v10
    const v10, 0x3e4ccccd
    invoke-static {v9, v10}, Ljava/lang/Math;->min(FF)F
    move-result v9
    const/high16 v10, 0x3f800000
    add-float/2addr v9, v10
    const/high16 v10, 0x41400000
    mul-float/2addr v10, p1
    sub-float v10, v8, v10
    const v11, 0x3faccccd
    mul-float/2addr v11, v8
    mul-float/2addr v11, v9
    iget v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    sub-float/2addr v11, v10
    mul-float/2addr v11, v1
    add-float/2addr v10, v11
    # v10 = W. inset: rest 12d -> lens -12d  => inset = 12d - 24d*a
    const/high16 v11, 0x41900000
    mul-float/2addr v11, v1
    const/high16 v2, 0x41200000
    sub-float/2addr v2, v11
    mul-float/2addr v2, p1
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;
    move-result-object v0
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I
    move-result v0
    int-to-float v0, v0
    sub-float v3, v0, v2
    # v3 = H, top v4 = (h-H)/2
    sub-float v4, v0, v3
    const/high16 v5, 0x40000000
    div-float/2addr v4, v5
    div-float/2addr v10, v5
    sub-float v6, v7, v10
    add-float v8, v7, v10
    add-float v9, v4, v3
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->rect:Landroid/graphics/RectF;
    invoke-virtual {v0, v6, v4, v8, v9}, Landroid/graphics/RectF;->set(FFFF)V
    div-float/2addr v3, v5
    return v3
.end method

.method public fore(Landroid/graphics/Canvas;)V
    .locals 14
    :try_start
    iget v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    iget-object v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v1
    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F
    invoke-virtual {v1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;
    move-result-object v1
    iget v1, v1, Landroid/content/res/Configuration;->uiMode:I
    and-int/lit8 v1, v1, 0x30
    const/16 v3, 0x20
    const/4 v13, 0x0
    if-ne v1, v3, :lt
    const/4 v13, 0x1
    :lt
    invoke-virtual {p0, v2}, Lcom/zing/zalo/zsplit/ZGlass;->geom(F)F
    move-result v3
    const/4 v1, 0x0
    cmpg-float v1, v3, v1
    if-ltz v1, :out
    iget-object v4, p0, Lcom/zing/zalo/zsplit/ZGlass;->rect:Landroid/graphics/RectF;
    iget-object v5, p0, Lcom/zing/zalo/zsplit/ZGlass;->paint:Landroid/graphics/Paint;
    iget-object v6, p0, Lcom/zing/zalo/zsplit/ZGlass;->path:Landroid/graphics/Path;
    if-nez v6, :hp
    new-instance v6, Landroid/graphics/Path;
    invoke-direct {v6}, Landroid/graphics/Path;-><init>()V
    iput-object v6, p0, Lcom/zing/zalo/zsplit/ZGlass;->path:Landroid/graphics/Path;
    :hp
    invoke-virtual {v6}, Landroid/graphics/Path;->reset()V
    sget-object v7, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;
    invoke-virtual {v6, v4, v3, v3, v7}, Landroid/graphics/Path;->addRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Path$Direction;)V
    # alpha int v7 = 255*a
    const/16 v7, 0xff
    # bar color v8
    const v8, -0x80807
    if-eqz v13, :bc
    const v8, -0xd9d9d8
    :bc
    const/4 v9, 0x0
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;
    sget-object v9, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    # outer shadow only
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I
    invoke-virtual {p1, v6}, Landroid/graphics/Canvas;->clipOutPath(Landroid/graphics/Path;)Z
    invoke-virtual {v5, v8}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {v5, v7}, Landroid/graphics/Paint;->setAlpha(I)V
    const/high16 v9, 0x41200000
    mul-float/2addr v9, v2
    const/4 v10, 0x0
    const/high16 v11, 0x40000000
    mul-float/2addr v11, v2
    const/high16 v12, 0x42000000
    mul-float/2addr v12, v0
    const/high16 v7, 0x41800000
    add-float/2addr v12, v7
    float-to-int v12, v12
    shl-int/lit8 v12, v12, 0x18
    const/16 v7, 0xff
    invoke-virtual {v5, v9, v10, v11, v12}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    invoke-virtual {v5}, Landroid/graphics/Paint;->clearShadowLayer()V
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V
    # interior: layer with alpha, clipped
    invoke-virtual {p1, v4, v7}, Landroid/graphics/Canvas;->saveLayerAlpha(Landroid/graphics/RectF;I)I
    invoke-virtual {p1, v6}, Landroid/graphics/Canvas;->clipPath(Landroid/graphics/Path;)Z
    invoke-virtual {v5, v8}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    invoke-virtual {p0, p1, v4, v3, v8}, Lcom/zing/zalo/zsplit/ZGlass;->refract(Landroid/graphics/Canvas;Landroid/graphics/RectF;FI)Z
    move-result v9
    if-nez v9, :nomag
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v9
    if-eqz v9, :nomag
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I
    const v10, 0x3e3851ec
    mul-float/2addr v10, v0
    const/high16 v11, 0x3f800000
    add-float/2addr v10, v11
    invoke-virtual {v4}, Landroid/graphics/RectF;->centerX()F
    move-result v11
    invoke-virtual {v4}, Landroid/graphics/RectF;->centerY()F
    move-result v12
    invoke-virtual {p1, v10, v10, v11, v12}, Landroid/graphics/Canvas;->scale(FFFF)V
    invoke-virtual {v9}, Landroid/view/View;->getLeft()I
    move-result v10
    int-to-float v10, v10
    invoke-virtual {v9}, Landroid/view/View;->getTop()I
    move-result v11
    int-to-float v11, v11
    invoke-virtual {p1, v10, v11}, Landroid/graphics/Canvas;->translate(FF)V
    invoke-virtual {v9, p1}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V
    :nomag
    const v9, 0x0f000000
    if-eqz v13, :tn
    const v9, 0x1affffff
    :tn
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    # top sheen
    iget v9, v4, Landroid/graphics/RectF;->top:F
    invoke-virtual {v4}, Landroid/graphics/RectF;->centerY()F
    move-result v10
    const v11, 0x4cffffff
    const v12, 0xffffff
    if-eqz v13, :sh
    const v11, 0x1affffff
    :sh
    invoke-static {v5, v9, v10, v11, v12}, Lcom/zing/zalo/zsplit/ZGlass;->grad(Landroid/graphics/Paint;FFII)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    const/4 v9, 0x0
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;
    # rims (inside layer so they fade with alpha)
    sget-object v9, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    invoke-virtual {v5, v2}, Landroid/graphics/Paint;->setStrokeWidth(F)V
    const v9, 0x1a000000
    if-eqz v13, :r1
    const v9, 0x33ffffff
    :r1
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    const/high16 v9, 0x3fc00000
    mul-float/2addr v9, v2
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setStrokeWidth(F)V
    invoke-virtual {v4, v9, v9}, Landroid/graphics/RectF;->inset(FF)V
    sub-float v3, v3, v9
    iget v10, v4, Landroid/graphics/RectF;->top:F
    iget v11, v4, Landroid/graphics/RectF;->bottom:F
    const v9, -0x1
    const v12, 0x33ffffff
    if-eqz v13, :r2
    const v9, 0x7fffffff
    const v12, 0xffffff
    :r2
    invoke-static {v5, v10, v11, v9, v12}, Lcom/zing/zalo/zsplit/ZGlass;->grad(Landroid/graphics/Paint;FFII)V
    invoke-virtual {p1, v4, v3, v3, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V
    const/4 v9, 0x0
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;
    sget-object v9, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V
    const/16 v9, 0xff
    invoke-virtual {v5, v9}, Landroid/graphics/Paint;->setAlpha(I)V
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :out
    :out
    return-void
.end method

.method public uni(Ljava/lang/String;F)V
    .locals 1
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->rs:Landroid/graphics/RuntimeShader;
    invoke-virtual {v0, p1, p2}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;F)V
    return-void
.end method

.method public refract(Landroid/graphics/Canvas;Landroid/graphics/RectF;FI)Z
    .locals 10
    :try_start
    invoke-virtual {p1}, Landroid/graphics/Canvas;->isHardwareAccelerated()Z
    move-result v0
    if-eqz v0, :fail
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v1, 0x21
    if-lt v0, v1, :fail
    invoke-virtual {p0}, Lcom/zing/zalo/zsplit/ZGlass;->tabs()Landroid/view/ViewGroup;
    move-result-object v9
    if-eqz v9, :fail
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->node:Landroid/graphics/RenderNode;
    if-nez v0, :hn
    new-instance v0, Landroid/graphics/RenderNode;
    const-string v1, "zlens"
    invoke-direct {v0, v1}, Landroid/graphics/RenderNode;-><init>(Ljava/lang/String;)V
    iput-object v0, p0, Lcom/zing/zalo/zsplit/ZGlass;->node:Landroid/graphics/RenderNode;
    :hn
    iget-object v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->rs:Landroid/graphics/RuntimeShader;
    if-nez v1, :hs
    new-instance v1, Landroid/graphics/RuntimeShader;
    const-string v2, "uniform shader content;\nuniform float2 size;\nuniform float radius;\nuniform float edge;\nuniform float strength;\nuniform float mag;\nuniform float pad;\nfloat sd(float2 p, float2 b, float r){ float2 q=abs(p)-b+float2(r); return length(max(q,float2(0.0)))+min(max(q.x,q.y),0.0)-r; }\nhalf4 main(float2 xy){\n float2 c=size*0.5;\n float2 p=xy-float2(pad)-c;\n float d=sd(p,c,radius);\n if(d>0.0) return content.eval(xy);\n float2 g=float2(sd(p+float2(1.0,0.0),c,radius)-sd(p-float2(1.0,0.0),c,radius), sd(p+float2(0.0,1.0),c,radius)-sd(p-float2(0.0,1.0),c,radius));\n float gl=length(g);\n float2 n=gl>0.0001 ? g/gl : float2(0.0);\n float k=clamp(1.0+d/edge,0.0,1.0);\n k=k*k*k;\n float2 base=float2(pad)+c+p/mag;\n float o=k*strength;\n half4 r=content.eval(base+n*o);\n half4 gg=content.eval(base+n*o*1.18);\n half4 b=content.eval(base+n*o*1.36);\n return half4(r.r,gg.g,b.b,gg.a);\n}"
    invoke-direct {v1, v2}, Landroid/graphics/RuntimeShader;-><init>(Ljava/lang/String;)V
    iput-object v1, p0, Lcom/zing/zalo/zsplit/ZGlass;->rs:Landroid/graphics/RuntimeShader;
    :hs
    iget-object v8, p0, Lcom/zing/zalo/zsplit/ZGlass;->host:Landroid/view/View;
    invoke-virtual {v8}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v8
    invoke-virtual {v8}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v8
    iget v8, v8, Landroid/util/DisplayMetrics;->density:F
    # pad v7 = 24d
    const/high16 v7, 0x41c00000
    mul-float/2addr v7, v8
    invoke-virtual {p2}, Landroid/graphics/RectF;->width()F
    move-result v2
    invoke-virtual {p2}, Landroid/graphics/RectF;->height()F
    move-result v3
    const/high16 v4, 0x40000000
    mul-float/2addr v4, v7
    add-float/2addr v4, v2
    float-to-int v4, v4
    const/high16 v5, 0x40000000
    mul-float/2addr v5, v7
    add-float/2addr v5, v3
    float-to-int v5, v5
    const/4 v6, 0x0
    invoke-virtual {v0, v6, v6, v4, v5}, Landroid/graphics/RenderNode;->setPosition(IIII)Z
    invoke-virtual {v0, v4, v5}, Landroid/graphics/RenderNode;->beginRecording(II)Landroid/graphics/RecordingCanvas;
    move-result-object v6
    iget v4, p2, Landroid/graphics/RectF;->left:F
    sub-float v4, v7, v4
    iget v5, p2, Landroid/graphics/RectF;->top:F
    sub-float v5, v7, v5
    invoke-virtual {v6, v4, v5}, Landroid/graphics/Canvas;->translate(FF)V
    invoke-virtual {v6, p4}, Landroid/graphics/Canvas;->drawColor(I)V
    invoke-virtual {v9}, Landroid/view/View;->getLeft()I
    move-result v4
    int-to-float v4, v4
    invoke-virtual {v9}, Landroid/view/View;->getTop()I
    move-result v5
    int-to-float v5, v5
    invoke-virtual {v6, v4, v5}, Landroid/graphics/Canvas;->translate(FF)V
    invoke-virtual {v9, v6}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V
    invoke-virtual {v0}, Landroid/graphics/RenderNode;->endRecording()V
    const-string v4, "size"
    invoke-virtual {v1, v4, v2, v3}, Landroid/graphics/RuntimeShader;->setFloatUniform(Ljava/lang/String;FF)V
    const-string v4, "radius"
    invoke-virtual {p0, v4, p3}, Lcom/zing/zalo/zsplit/ZGlass;->uni(Ljava/lang/String;F)V
    const-string v4, "pad"
    invoke-virtual {p0, v4, v7}, Lcom/zing/zalo/zsplit/ZGlass;->uni(Ljava/lang/String;F)V
    # edge = min(radius, 18d)
    const/high16 v5, 0x41900000
    mul-float/2addr v5, v8
    invoke-static {v5, p3}, Ljava/lang/Math;->min(FF)F
    move-result v5
    const-string v4, "edge"
    invoke-virtual {p0, v4, v5}, Lcom/zing/zalo/zsplit/ZGlass;->uni(Ljava/lang/String;F)V
    iget v5, p0, Lcom/zing/zalo/zsplit/ZGlass;->lensA:F
    # strength = d*(5 + 13a)
    const/high16 v6, 0x41500000
    mul-float/2addr v6, v5
    const/high16 v4, 0x40a00000
    add-float/2addr v6, v4
    mul-float/2addr v6, v8
    const-string v4, "strength"
    invoke-virtual {p0, v4, v6}, Lcom/zing/zalo/zsplit/ZGlass;->uni(Ljava/lang/String;F)V
    # mag = 1 + 0.1a
    const v6, 0x3dcccccd
    mul-float/2addr v6, v5
    const/high16 v4, 0x3f800000
    add-float/2addr v6, v4
    const-string v4, "mag"
    invoke-virtual {p0, v4, v6}, Lcom/zing/zalo/zsplit/ZGlass;->uni(Ljava/lang/String;F)V
    const-string v4, "content"
    invoke-static {v1, v4}, Landroid/graphics/RenderEffect;->createRuntimeShaderEffect(Landroid/graphics/RuntimeShader;Ljava/lang/String;)Landroid/graphics/RenderEffect;
    move-result-object v4
    invoke-virtual {v0, v4}, Landroid/graphics/RenderNode;->setRenderEffect(Landroid/graphics/RenderEffect;)Z
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I
    iget v4, p2, Landroid/graphics/RectF;->left:F
    sub-float/2addr v4, v7
    iget v5, p2, Landroid/graphics/RectF;->top:F
    sub-float/2addr v5, v7
    invoke-virtual {p1, v4, v5}, Landroid/graphics/Canvas;->translate(FF)V
    invoke-virtual {p1, v0}, Landroid/graphics/Canvas;->drawRenderNode(Landroid/graphics/RenderNode;)V
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V
    const/4 v0, 0x1
    return v0
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :fail
    :fail
    const/4 v0, 0x0
    return v0
.end method
