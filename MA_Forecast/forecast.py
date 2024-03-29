from datetime import datetime

filename = "MA_Forecast/Daily Household Transactions.csv"
# filename = "test.csv"
data_col = 0
amount_col = 6
datefrmt = "%m-%d-%Y"


# method to read the csv dataset
def load_csv():
    data = []
    with open(filename, "r") as file:
        for line in file:
            items = line.split(",")
            entry = {items[data_col]: items[amount_col]}
            data.append(entry)
    return data


# method to format the dataset into appropriate data types
def format_data(data):
    entries = {}
    for entry in data:
        try:
            date = datetime.strptime(list(entry.keys())[0], datefrmt)
            amount = list(entry.values())[0]
            amount_fix = list(map(float, amount))

            if date not in entries:
                entries[date] = []

            entries[date].append(amount_fix)
        except:
            pass
    return entries


# method to compute total for the day
def compute_daily_sum(entries):
    for date, items in entries.items():
        total = sum(items[0])

        entries[date] = total

    return dict(sorted(entries.items(), reverse=True))


# method to calculate moving average
def getForecast(today, days, entries):
    values = []

    for date, avg in entries.items():
        if (today - date).days <= days and (today - date).days > 0:
            values.append(avg)
    try:
        return sum(values) / len(values)
    except:
        return 0


if __name__ == "__main__":
    data = load_csv()
    entries = format_data(data)
    entries = compute_daily_sum(entries)

    monthly_avg = None

    forecast = []

    for key, value in entries.items():
        expected = getForecast(key, 7, entries)
        data = {"date": key, "actual": value, "predicted": expected}
        forecast.append(data)

    keys = forecast[0].keys()

    with open("MA_Forecast/forecast.csv", "w") as output_file:
        output_file.write(",".join(keys) + "\n")

        # Write each dictionary's values as a CSV row
        for row in forecast:
            values = [str(row[key]) for key in keys]
            output_file.write(",".join(values) + "\n")
