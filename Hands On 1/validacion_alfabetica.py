def validate_alpha(s):
    return s.isalpha()
input_str = "HelloWorld 2"
if validate_alpha(input_str):
    print(f"La Cadena {input_str} es válida.")
else:
    print(f"Cadena {input_str} es inválida.")