def validate_real(s):
    try:
        float(s)
        return True
    except ValueError:
        return False
input_str = "-123.456"
if validate_real(input_str):
    print(f"El Número {input_str} es válido.")
else:
    print(f"EL Número {input_str} es inválido.")