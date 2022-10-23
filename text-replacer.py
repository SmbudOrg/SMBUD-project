inputfile = "prova.xml"
outputfile = "database.xml"

replacetext = [["&Agrave;", "a"], ["&Aacute;", "A"], ["&Acirc;", "A"], ["&Atilde;", "A"], 
  ["&Auml;", "A"], ["&Aring;", "A"], ["&AElig;", "AE"], ["&Ccedil;", "C"], ["&Egrave;", "E"], 
  ["&Eacute;", "E"], ["&Ecirc;", "E"], ["&Euml;", "E"], ["&Igrave;", "I"], ["&Iacute;", "I"], 
  ["&Icirc;", "I"], ["&Iuml;", "I"], ["&ETH;", "E"], ["&Ntilde;", "N"], ["&Ograve;", "O"], 
  ["&Oacute;", "O"], ["&Ocirc;", "O"], ["&Otilde;", "O"], ["&Ouml;", "O"], ["&Oslash;", "O"], 
  ["&Ugrave;", "U"], ["&Uacute;", "U"], ["&Ucirc;", "U"], ["&Uuml;", "U"], ["&Yacute", "Y"], 
  ["&THORN;", "TH"], ["&szlig;", "sz"], ["&agrave", "a"], ["&aacute;", "a"], ["&acirc;", "a"],
  ["&atilde;", "a"], ["&auml;", "a"], ["&aring;", "a"], ["&aelig;", "ae"], ["&ccedil;", "c"], 
  ["&egrave;", "e"], ["&eacute;", "e"], ["&ecirc;", "e"], ["&euml;", "e"], ["&igrave", "i"], 
  ["&iacute;", "i"], ["&icirc;", "i"], ["&iuml;", "i"], ["&eth;", "e"], ["&ntilde;", "n"], 
  ["&ograve;", "o"], ["&oacute;", "o"], ["&ocirc;", "o"], ["&otilde;", "o"], ["&ouml;", "o"], 
  ["&oslash", "o"], ["&ugrave;", "u"], ["&uacute;", "u"], ["&ucirc", "u"], ["&uuml;", "u"],
  ["&yacute;", "y"], ["&thorn;", "th"], ["&yuml;", "y"]]

with open(inputfile, encoding="utf8") as input:
  with open(outputfile, "w") as output:
    while True:

      line = input.readline()
      if(len(line) == 0):
        break

      for i in range(0, len(replacetext)):
        try:
          line = line.replace(replacetext[i][0], replacetext[i][1])
        except AttributeError:
          pass
      
      output.writelines(line)
  
print("Program ended")
