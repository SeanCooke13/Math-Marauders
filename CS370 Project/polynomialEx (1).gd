extends Control

var levelsCompleted: int = 0
var username: String = ""
var classNumber: int = 0
var difficulty: int = 1

func _ready():
	# Call generateNewPolynomial with username and classNumber parameters
	generateNewPolynomial(username, classNumber)

func generateNewPolynomial(username_param: String, classNumber_param: int):
	username = username_param
	classNumber = classNumber_param
	if levelsCompleted >= 10:
		difficulty = 3
	elif levelsCompleted >= 5:
		difficulty = 2
	var polynomialLabel = $Label
	var polynomial = generateRandomPolynomial(2, 3, difficulty)
	polynomialLabel.text = "Polynomial Equation: " + polynomial

func generateRandomPolynomial(degree: int, numTerms: int, difficulty: int) -> String:
	var equation: String = ""
	
	for i in range(numTerms):
		var coefficient: int = randi() % 10 + 1  
		var exponent: int = randi() % degree + 1  
		var operator: String = ["+", "-", "*"][randi() % 3]  
		
		if i > 0:
			equation += " " + operator + " "  
		
		if exponent > 1:
			equation += str(coefficient) + "x^" + str(exponent)  
		else:
			equation += str(coefficient) + "x"  
	
	levelsCompleted += 1
	
	if levelsCompleted >= 3:
		levelsCompleted = 0
		switchToMenuScene("dummy_result") # Pass a dummy result as an argument
	
	return equation

func _on_Button_pressed():
	var answer = $LineEdit.text.strip_edges()
	if answer == "":
		$Label.text = "Please enter an answer to unlock the safe and collect the Golden Ipads!"
	else:
		var correctAnswer = calculateCorrectAnswer($Label.text) # Pass the polynomial equation as an argument
		if answer == correctAnswer:
			$Label.text = "Correct! You unlocked the safe and collected the Golden Ipads!"
			switchToMenuScene(answer) # Pass the answer as an argument
		else:
			$Label.text = "Wrong answer! Try again!"
			$LineEdit.text = "" # Clear the input field for the user to try again

func switchToMenuScene(result: String):
	# Implement logic to switch to the menu scene
	get_tree().change_scene("res://menu_scene.tscn")
	var menu_scene = get_node("/root/menu_scene")
	menu_scene.show_result(result, username, classNumber)

func calculateCorrectAnswer(polynomial: String) -> String:
	# Remove spaces from the polynomial string
	polynomial = polynomial.replace(" ", "")
	
	# Split the polynomial string into individual terms
	var terms = polynomial.split("+")
	var result = 0

	# Iterate through each term and evaluate it
	for term in terms:
		if term.find("x^") != -1:  # If the term contains x^
			var parts = term.split("x^")
			var coefficient = parts[0].to_int()
			var exponent = parts[1].to_int()
			result += coefficient * pow(42, exponent)  # Assuming the variable is x and the correct answer is 42
		elif term.find("x") != -1:  # If the term contains x (but no exponent)
			var parts = term.split("x")
			var coefficient = parts[0].to_int()
			result += coefficient * 42  # Assuming the variable is x and the correct answer is 42
		else:  # If the term is a constant
			result += term.to_int()

	return str(result)
