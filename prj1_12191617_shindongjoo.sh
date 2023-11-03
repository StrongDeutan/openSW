echo "---------------------------"
echo "User Name: 신동주"
echo "Student Number: 12191617"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of 'action' genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.item'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users form 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "---------------------------"

while true; do
	read -p "Enter your choice [ 1-9 ] " number
	if [ "$number" == "9" ]; then
		echo "bye!"
		break
	fi
	#9
	
	if [ "$number" == "1" ]; then
		read -p "Please enter 'movie id' (1~1682) : " m_id
		awk -v line_num="$m_id" 'NR==line_num' u.item
	fi
	#1
	
	if [ "$number" == "2" ]; then
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " yORn
		if [ "$yORn" == "y" ]; then
			awk -F'|' '$7 == "1" { print $1, $2; check++; if(check == 10) exit; }' u.item
		fi
	fi
	#2
	
	if [ "$number" == "3" ]; then
		read -p "Please enter the 'movie id' (1~1682) : " m_id
		total=0
		count=0
		fileName="u.data"
		average=$(awk -v search_value="$m_id" '$2 == search_value { sum += $3; count++} END { if (count > 0) print sum / count; else print 0}' "$fileName")

		echo "average rating of $m_id: $average"
	fi
	#3
	
	if [ "$number" == "4" ]; then
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n) : " yORn
		if [ "$yORn" == "y" ]; then
			_input="u.item"
			sed -i "s/[^|]\+//4" "$_input"
			head -n 10 u.item
		fi
	fi
	#4
	
	if [ "$number" == "5" ]; then
		read -p "Do you want to get the data about users from 'u.user'? (y/n): " yORn
		if [ "$yORn" == "y" ]; then
			file="u.user"
			for row in {1..10}; do
				data=$(sed -n "${row}p" "$file")
				id=$(echo "$data" | awk -F '|' '{print $1}')
				age=$(echo "$data"| awk -F '|' '{print $2}')
				gender=$(echo "$data" | awk -F '|' '{print $3}')
				job=$(echo "$data" | awk -F '|' '{print $4}')
				gen="male"
				if [ "$gender" == "F" ]; then
					gen="female"
				fi
				sen="user $id is $age years old $gen $job"
				echo $sen
			done

		fi
	fi
	#5
	
	if [ "$number" == "6" ]; then
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n): " yORn
		if [ "$yORn" == "y" ]; then
			sed -i 's/01-Jan-1995/19950101/g' u.item
			sed -i 's/01-Jan-1962/19620101/g' u.item
			sed -i 's/25-Oct-1996/19961025/g' u.item
			sed -i 's/01-Jan-1996/19960101/g' u.item
			sed -i 's/20-Sep-1996/19960920/g' u.item
			sed -i 's/06-Feb-1998/19980206/g' u.item
			sed -i 's/01-Jan-1998/19980101/g' u.item
			sed -i 's/01-Jan-1994/19940101/g' u.item
			sed -i 's/08-Mar-1996/19960308/g' u.item
			tail -n 10 u.item
		fi
	fi
	#6
	
	if [ "$number" == "7" ]; then
		read -p "Please enter the 'user id' (1~943) : " u_id
		file="u.data"
		awk -v col=1 -v val="$u_id" -v file="$file" '
		$col == val { arr[NR] = $2 }
		END { asort(arr) 
		for (i = 1; i <= length(arr); i++)
			{ if(i > 1) { output = output "|" }  output = output arr[i] } print output }
		' "$file" | tee "output_data"
		
		echo " " #endl

		IFS='|' read -ra input_array < "output_data"
		for i in {0..9}; do
			string=$(awk -v search="${input_array[i]}" -F '|' '$1 == search { print $1, $2 }' "u.item")
			echo "$string"
		done
	fi
	#7
	
	if [ "$number" == "8" ]; then
		read -ep "Do you want to get the average 'rating' of movies \nrated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n) : " yORn
		if [ "$yORn" == "y" ]; then
			awk -F '|' '($2 >= 20 && $2 <= 29 && $4 == "programmer") { print $1 }' u.user > output_8
			IFS=$'\n' read -d '' -ra input_array < "output_8"
			

			#20~29세이며 직업이 programmer인 user_id를 배열로 저장 하였으나 이후 movie id와 대조하여 평균을 내는 것을 구현하지 못하였음.
			done
		fi
	fi

done
