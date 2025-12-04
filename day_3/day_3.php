<?php
	$input = fopen("input.txt", "r");
	$sum = 0;
	while (!feof($input)) {
		$string = fgets($input);
		$max1 = 0;
		$max2 = 0;
		$string = str_split($string);
		$i = 0;
		while ($i < count($string)-3) {
			$char = (int)$string[$i];
			if ($char > $max1) {
				$max1 = $char;
				$max2 = 0;
			} else {
				if ($char > $max2) {
					$max2 = $char;
				}
			}
			$i = $i + 1;
		}
		if ($string[$i] > $max2) {
			$max2 = $string[$i];
		}
		$sum += ($max1 * 10) + $max2;
	}

	echo ($sum);
	echo ("\n");
?>

<?php
	$input = fopen("input.txt", "r");
	$sum = 0;
	$n_batteries = 12;

	while (($string = fgets($input)) !== false) {
		$string = str_split(trim($string));
		$num_digits = count($string);
		$result_digits = [];

		$start = 0;
		$remaining = $n_batteries;

		while ($remaining > 0) {
			$end = $num_digits - $remaining;
			$max_digit = -1;
			$max_index = $start;

			for ($i = $start; $i <= $end; $i++) {
				$digit = (int)$string[$i];
				if ($digit > $max_digit) {
					$max_digit = $digit;
					$max_index = $i;
					if ($digit == 9) break;
				}
			}

			$result_digits[] = $max_digit;
			$start = $max_index + 1;
			$remaining--;
		}
		$number = 0;
		foreach ($result_digits as $digit) {
			$number = $number * 10 + $digit;
		}

		$sum += $number;
	}

	fclose($input);

	echo $sum;
?>