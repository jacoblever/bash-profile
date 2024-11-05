def main():
    string = raw_input("Enter word: ")
    roo_letter_string = roo_letters(string)
    print("\nCopy this string into slack: \n\n{}\n\nYou're welcome!\n".format(roo_letter_string))

def roo_letters(word):
    new_string = ""
    for char in word:
        if char != " ":
            new_string += ":letter_{}:".format(char)
    return new_string

if __name__ == '__main__':
   main()

