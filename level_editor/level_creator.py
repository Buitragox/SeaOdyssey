import json
import os

SAVE_PATH = "./levels/"

data = {}

def save_data():
    json_data = json.dumps(data, indent=4)
    with open(SAVE_PATH + "level1.json", "w") as f:
        f.write(json_data)


def add_enemy(wave):
    print()
    enemy = {}
    enemy["type"] = input("Type: ")
    enemy["damage"] = float(input("Damage: "))
    enemy["amount"] = float(input("How many: "))
    wave["enemies"].append(enemy)


def add_wave():
    new_wave = {"delay": 15, "enemies": []}

    
    new_wave["delay"] = int(input("Wave start delay (seconds):"))

    opc = ""
    while opc != "-1":
        print("\n=== Wave editor ===")
        print(" 1. Add enemy")
        print(" -1. End wave")
        opc = input("> ")

        if opc == "1":
            add_enemy(new_wave)
            

    data["waves"].append(new_wave)
    

def main():
    data["waves"] = []

    
    opc = ""
    while opc != "-1":
        print("\n=== Level editor ===")
        print(" 1. Add wave")
        print(" 0. Save")
        print("-1. Exit")
        opc = input("> ")

        if opc == "0":
            save_data()
        elif opc == "1":
            add_wave()


main()