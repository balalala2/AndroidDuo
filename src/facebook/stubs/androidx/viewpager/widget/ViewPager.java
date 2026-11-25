package androidx.viewpager.widget;
import android.content.Context;
import android.view.ViewGroup;
public class ViewPager extends ViewGroup {
    public ViewPager(Context c) { super(c); }
    @Override protected void onLayout(boolean c, int l, int t, int r, int b) {}
    public PagerAdapter getAdapter() { return null; }
    public int getCurrentItem() { return 0; }
    public void setCurrentItem(int item, boolean smooth) {}
    public int getPageMargin() { return 0; }
}
