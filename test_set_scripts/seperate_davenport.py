import pandas as pd

davenport_stars = pd.read_csv("davenport_stars.tsv", sep=";")

print(davenport_stars.head())

davenport_stars[["KIC","Nfl","Nfl68"]].to_csv("KIC_stars.csv", index=False)

print("completed parsing")
