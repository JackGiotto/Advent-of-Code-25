fun getMove(c, n) =
	if c = #"L"
		then ~n
		else n


fun check (p) =
	if p < 0 then check(p+100)
	else if p >= 100 then check(p-100)
	else p

fun countZeros moves =
	let
		fun aux([], pos, count) = count
		| aux((c,n)::xs, pos, count) =
			let
				val move = getMove(c,n)
				val newPos = check(pos + move)
				val count2 = (if newPos = 0 then count +1 else count)
			in
				aux(xs, newPos, count2)
			end
	in
		aux(moves, 50, 0)
	end


fun check2 (startPos, move) =
    let
        val s = startPos
        val m = move
        val finalPos = check(s + m)
        val crossings =
            if m > 0 then
                let
                    val first = if s = 0 then 100 else 100 - s
                in
                    if m < first then 0
                    else 1 + (m - first) div 100
                end
            else if m < 0 then
                let
                    val d = ~m
                    val first = if s = 0 then 100 else s
                in
                    if d < first then 0
                    else 1 + (d - first) div 100
                end
            else 0
    in
        (finalPos, crossings)
    end


fun countZeros2 moves =
	let
		fun aux([], pos, count) = count
		| aux((c,n)::xs, pos, count) =
			let
				val move = getMove(c,n)
				val (newPos, extraCount) = check2(pos, move)
			in
				aux(xs, newPos, count + extraCount)
			end
	in
		aux(moves, 50, 0)
	end


fun parseInput s =
	let
		(* Estrae i digit da una lista di char *)
		fun takeDigits [] = ([], [])
			| takeDigits (c::cs) =
			if Char.isDigit c then
				let val (digits, rest) = takeDigits cs
				in (c::digits, rest)
				end
			else ([], c::cs)

		fun digitsToInt [] = 0
			| digitsToInt cs = valOf(Int.fromString(String.implode cs))

		fun parse [] = []
			| parse (#"\n"::cs) = parse cs
			| parse (#"\r"::cs) = parse cs
			| parse (c::cs) =
				if Char.isAlpha c then
					let
						val (digits, rest) = takeDigits cs
						val num = digitsToInt digits
					in
						(c, num) :: parse rest
					end
				else parse cs
	in
		parse (String.explode s)
	end

fun readFile filename =
    let val f = TextIO.openIn filename
    in TextIO.inputAll f before TextIO.closeIn f
    end

val result = countZeros2 (parseInput (readFile "input.txt"))