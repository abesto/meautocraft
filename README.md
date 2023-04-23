# meautocraft

A configurable, plug-and-play autocrafting / stockpiling system.

![image](https://user-images.githubusercontent.com/59982/233852087-2dd7e049-28bd-47db-8eb5-174d0a7cffed.png)
![image](https://user-images.githubusercontent.com/59982/233852225-777b71c3-a964-4fd5-9ee6-cf5d50c14fe3.png)

## Requirements

* [CC:Tweaked](https://tweaked.cc/)
* [Applied Energistics 2](https://appliedenergistics.github.io/)
* [Advanced Peripherals](https://docs.intelligence-modding.de/)

## Installation

### Hardware

* Place an Advanced CC:Tweaked computer (a basic one won't work with the current implementation; PRs welcome I guess!)
* Place an Advanced Peripherals [ME Bridge](https://docs.intelligence-modding.de/peripherals/me_bridge/) on one side of the computer, connected to your AE2 grid.
* Place a monitor on another side of your computer. You'll probably want to make it fairly big.

### Software

Grab [`gitget`](http://www.computercraft.info/forums2/index.php?/topic/17387-gitget-version-2-release/)

```sh
pastebin get W5ZkVYSi gitget
```

Grab `meautocraft`. Watch out, this will *overwrite* your `startup` file!

```sh
gitget abesto meautocraft main
```

If you want to control installation, you can pass an extra argument to `gitget`. For example, to fetch the code into `downloads/meautocraft`:

```sh
gitget abesto meautocraft main downloads/meautocraft
```

That's it, you're good to go! Run `startup` (or reboot the computer) to get things rolling. `meautocraft` will now ensure the items you requested are stockpiled to the amount you requested every few seconds. See below for how to set the number of items you want.

## How It Works

Autocrafting runs on second tab. You can click through there to check on logs / errors. The attached screen will also switch to showing red error text if something goes wrong.

The attached monitor is updated with the stockpile status, with items being crafted always sorted to the top - so that you always see them, even if you have more items to stockpile than available lines on the monitor.

## Usage

The startup script will change the directory of your shell to `meautocraft`, so your prompt should be `meautocraft>`. It also sets up completions for `stockpile` and `get`. From here, you can:

* `stockpile Iron Ingot 128` to ensure you always have 128 iron ingots. Note that the item name is case sensitive!
* `get Iron Ingot` to see how many iron ingots you've currently requested (if any)

Note that `meautocraft` will get very confused (i.e. it print big red errors) if you have multiple craftable items in your ME network with the same human-friendly name; for example if you have recipes copper ingots from multiple mods. In these situations, it'll arbitrarily pick one variant. This situation is probably generally a bad idea anyway, and you should enable substitutions on your recipes. This trade-off was picked to both use human-friendly names (so that you can type `Iron Ingot` instead of `minecraft:iron_ingot`), and keep code complexity as low as possible.

## Configuration

Some aspects of `meautocraft` behavior can be tweaked using CC:Tweaked [settings](https://tweaked.cc/module/settings.html) (see `help settings` on a CC:Tweaked shell). The available settings:

| Setting | Default | Description |
|---------|---------|-------------|
| `meautocraft.requested_amounts_path` | `meautocraft.requested_amounts_path` | File path used to store the amount of items you requested to be stockpiled. The file contents are read/written using `textutils.[un]serialize`, so it's effectively a Lua source file with a single table in it. Feel free to check it out, or even edit it if needed. |
| `meautocraft.requested_amounts_path` | `meautocraft.data/craftables` | File path used to store information about all craftable items in the ME network. Updated each time `meautocraft` does a round of autocrafting. Mainly useful because querying ME takes many seconds; caching the results allows completions on the `stockpile` script to be instantenous. |
| `meautocraft.threshold` | `0.95` | Percentage of requested amount under which autocrafting will start. For example, if you requested 100 Sticks, and the threshold is set to `0.95`, we won't start crafting at 96 available sticks. |
| `meautocraft.interval` | 3 | Number of seconds between runs of autocrafting |
| `meautocraft.monitor` | `right` | Used to determine which monitor to use if the computer has multiple monitors attached. Ignored if there's only a single monitor. |
