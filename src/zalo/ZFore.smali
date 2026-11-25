.class public final Lcom/zing/zalo/zsplit/ZFore;
.super Landroid/graphics/drawable/Drawable;

.field public g:Lcom/zing/zalo/zsplit/ZGlass;

.method public constructor <init>(Lcom/zing/zalo/zsplit/ZGlass;)V
    .locals 0
    invoke-direct {p0}, Landroid/graphics/drawable/Drawable;-><init>()V
    iput-object p1, p0, Lcom/zing/zalo/zsplit/ZFore;->g:Lcom/zing/zalo/zsplit/ZGlass;
    return-void
.end method

.method public draw(Landroid/graphics/Canvas;)V
    .locals 1
    iget-object v0, p0, Lcom/zing/zalo/zsplit/ZFore;->g:Lcom/zing/zalo/zsplit/ZGlass;
    invoke-virtual {v0, p1}, Lcom/zing/zalo/zsplit/ZGlass;->fore(Landroid/graphics/Canvas;)V
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
