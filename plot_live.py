import pandas as pd
import matplotlib.pyplot as plt
import time
import os

plt.ion()  # interactive mode on

fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(10, 6))

# Plant subplot
plant_line, = ax1.plot([0, 0.1], [0, 0], 'r-', label='Plant n')
ax1.set_ylabel("Plant n")
ax1.set_title("Live Plant State")
ax1.grid(True)
ax1.legend()

# Filter subplot
filter_line, = ax2.plot([0, 0.1], [0, 0], 'b--', label='Filter n')
ax2.set_xlabel("Time (s)")
ax2.set_ylabel("Filter n")
ax2.set_title("Live Filter Estimate")
ax2.grid(True)
ax2.legend()

ax2.ticklabel_format(useOffset=False, style='plain', axis='x')

# ✅ Draw once immediately with dummy data
fig.canvas.draw()
fig.canvas.flush_events()

while True:
    try:
        if not os.path.exists("log.csv"):
            time.sleep(0.1)
            continue

        df = pd.read_csv("log.csv", names=["time", "source", "n", "c", "trx"])
        if df.empty:
            time.sleep(0.1)
            continue

        df["time"] = pd.to_numeric(df["time"])
        df["time"] = df["time"] - df["time"].min()

       # latest_time = df["time"].max()
       # df = df[df["time"] > latest_time - 10]  # keep only last 10 seconds


        plant = df[df["source"] == "plant"]
        filt = df[df["source"] == "filter"]

        if plant.empty or filt.empty:
            time.sleep(0.1)
            continue

        plant_line.set_xdata(plant["time"])
        plant_line.set_ydata(plant["n"])
        filter_line.set_xdata(filt["time"])
        filter_line.set_ydata(filt["n"])

        ax1.relim()
        ax1.autoscale_view()
        ax2.relim()
        ax2.autoscale_view()

        fig.canvas.draw()
        fig.canvas.flush_events()

        time.sleep(0.1)

    except KeyboardInterrupt:
        break
    except Exception as e:
        print("Error:", e)
        time.sleep(0.5)
