public class hello {
	static { System.loadLibrary("hello"); }	
	public static native int sum(int a, int b);
}