import std.file;
import std.stdio;
import std.regex;
import std.conv;

bool isInvalid(long number) {
	char[] numberc = number.to!string.dup;

	int l = to!int(numberc.length);
	if (l%2 == 1) {
		return false;
	} else {
		int middle = l /2;
		for (int i = 0; i < middle; i++) {
			if (numberc[i] != numberc[l-middle+i]) {
				return false;
			}
		}
		return true;
	}

	return false;
}

bool isInvalid2(long number) {
	char[] numberc = number.to!string.dup;

	int l = to!int(numberc.length);
	// writeln(l);

	for (int i = 0; i < l / 2; i++) {
		char[] subarray = numberc[0 .. i+1];
		if ((l - (i+1)) % (i+1) != 0) {
			// writeln("yes");
			continue;
		} else {
			// writeln("no");
			int k = 0;
			size_t sublength = subarray.length;
			// writeln(sublength);
			bool flag = true;
			for (int j = i + 1; j < l; j++) {
				if (subarray[k] != numberc[j]) {
					flag = false;
					break;
				}
				k++;
				if (k == sublength) {
					k = 0;
				}
			}
			if (flag) return true;
		}
	}

	return false;
}

void getInvalidIDs(long start, long end, ref long[] invalidIDs, bool part2) {
	for (long i = start; i <= end; i++) {
		if (!part2) {
			if (isInvalid(i)) {
				invalidIDs ~= i;
			}
		} else {
			if (isInvalid2(i)) {
				invalidIDs ~= i;
			}
		}
	}
}

void main() {
	bool part2 = true;


	string content = readText("input.txt");
	auto r = regex(r"(\d+)-(\d+)");
	long[] invalidIDs;
	foreach (m; matchAll(content, r)) {
		getInvalidIDs(to!long(m.captures[1]), to!long(m.captures[2]), invalidIDs, part2);
	}

	long sum = 0;
	foreach (n; invalidIDs) {
		// writeln (n);
		sum += n;

	}
	writeln(sum);
	// writeln(content);
}
