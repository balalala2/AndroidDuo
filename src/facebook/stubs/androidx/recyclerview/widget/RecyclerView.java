package androidx.recyclerview.widget;
import android.content.Context;
import android.view.ViewGroup;
public class RecyclerView extends ViewGroup {
    public RecyclerView(Context c) { super(c); }
    @Override protected void onLayout(boolean c, int l, int t, int r, int b) {}
    public Adapter getAdapter() { return null; }
    public RecycledViewPool getRecycledViewPool() { return null; }
    public void invalidateItemDecorations() {}
    public void addOnScrollListener(OnScrollListener listener) {}
    public static abstract class OnScrollListener {
        public void onScrollStateChanged(RecyclerView recyclerView, int newState) {}
        public void onScrolled(RecyclerView recyclerView, int dx, int dy) {}
    }
    public static abstract class Adapter {
        public final void notifyDataSetChanged() {}
    }
    public static class RecycledViewPool {
        public void clear() {}
    }
}
