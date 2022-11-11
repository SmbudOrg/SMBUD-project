import json
import random

inputfile = "article-t1.json"
outputfile = "prova2.json"

#file con frasi e url, da scaricare e mettere nella stessa directory
sentencesfile = "sentences.json"
urlsfile = "image-urls.json"

#region FUNZIONI

#ritorna una lista di paragrafi
def paragraphs(min, max):
    global sentence_i
    n_sentences = random.randint(min, max)
    _paragraphs = []
    for i in range(0, n_sentences):
        _paragraphs.append(sentences[sentence_i])
        sentence_i = sentence_i + 1
        if (sentence_i >= len_sentences): sentence_i = 0
    return _paragraphs

#ritorna una lista di immagini
def images (min, max):
    global sentence_i, url_i
    n_images = random.randint(min, max)
    _images = []
    for i in range (0, n_images):
        url = urls[url_i]
        caption = sentences[sentence_i]
        image = { "url": url, "caption": caption }
        _images.append(image)
        url_i = url_i + 1
        sentence_i = sentence_i + 1
        if (url_i >= len_urls): url_i = 0
        if (sentence_i >= len_sentences): sentence_i = 0
    return _images

#ritorna una lista di sottosezioni
def subsections(min, max):
    n_subsections = random.randint(min, max)
    _subsections = []
    for i in range (0, n_subsections):
        subsect = { "paragraphs" : paragraphs(0,5), "images": images(0,3)}
        _subsections.append(subsect)
    return _subsections

#ritorna una lista di sezioni con sottosezioni nestate
def sections(min, max):
    n_sections = random.randint(min,max)
    _sections = []
    for i in range(0, n_sections):
        section = {"paragraphs" : paragraphs(0,5), "images" : images(0,3), "subsections": subsections(0,4)}
        _sections.append(section)
    return _sections

#endregion

#region DATI 

#estraggo i dati
data = json.load(open(inputfile, "r", encoding="utf-8"))
sentences = json.load(open(sentencesfile, "r", encoding="utf-8"))
urls = json.load(open(urlsfile, "r", encoding="utf-8"))

sentence_i = 0
len_sentences = len(sentences)
url_i = 0
len_urls = len(urls)

#endregion

#region CODICE

for i in range(0, len(data)):
    data[i]["text"] = {}

    data[i]["text"]["paragraphs"] = paragraphs(0, 5)
    data[i]["text"]["images"] = images(0,3)
    data[i]["text"]["sections"] = sections(0, 5)


json.dump(data, open(outputfile, "w", encoding="utf-8"), indent=4)

#endregion