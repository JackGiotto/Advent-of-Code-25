// package day_7;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.Iterator;

public class day_7 {

	public static void main(String[] args) throws Exception {
		int countHitted = 0;
		Set<Integer> columns_beam = new LinkedHashSet<>();
		java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader("input.txt"));
		String line;
		long ar[] = null;
		while ((line = br.readLine()) != null) {
			if (columns_beam.isEmpty()) {
				for (int i = 0; i < line.length(); i++) {
					char ch = line.charAt(i);
					if (ch == 'S') {
						ar = new long[line.length()];
						ar[i] = 1;
						columns_beam.add(i);
						break;
					}
				}
			} else {
				Set<Integer> tmp = new LinkedHashSet<>();
				Iterator<Integer> it = columns_beam.iterator();
				while (it.hasNext()) {
					int n = it.next();
					if (line.charAt(n) == '^') {
						countHitted++;
						int left = n - 1;
						int right = n + 1;
						if (left >= 0) {
							tmp.add(left);
							ar[left] += ar[n];
						}
						if (right < line.length()) {
							tmp.add(right);
							ar[right] += ar[n];
						}
						ar[n] = 0;
						it.remove();
					}
				}
				columns_beam.addAll(tmp);
			}
		}
		br.close();
		System.out.println(countHitted);

		long scenarios = 0;
		for (long e: ar) {
			scenarios += e;
		}
		System.out.println(scenarios);
	}
}