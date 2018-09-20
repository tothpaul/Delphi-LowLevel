// package fr.execute.android;

public final class test {
	
	public static void main(String... args) {
		System.out.println("ready\n");
		System.out.format("ArgCount = %d\n", args.length);
		for (int i = 0; i < args.length; i++) {
			System.out.format("Args[%d] = %s\n", i, args[i]);
		}
		int i = hello.sum(1, 2);
		System.out.format("1 + 2 = %d\n", i);
		System.out.format("bye.\n");
	}
}