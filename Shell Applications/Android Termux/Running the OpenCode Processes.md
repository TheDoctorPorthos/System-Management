What you don't have to do anymore is the **Pairing Step (adb pair)**.
Because you successfully connected yesterday, your unbranded Samsung firmware has already securely saved Termux's cryptographic handshake key under its "Paired Devices" list in Developer Options.
This means you never have to ask for a 6-digit pairing code or execute the pairing command on this network again.
### All You Need to Do to Reconnect
Since the key is permanently trusted, you only need to look at the **dynamic IP address and Port** under the main Wireless Debugging toggle and run the connect command.
 1. Go to **Settings > Developer Options > Wireless Debugging** and make sure the main toggle is turned **ON**.
 2. Look at the text that says **"IP address & Port"** (e.g., 127.0.0.1:39451 or 192.168.1.X:XXXXX). Note that the 5-digit port number changes every time the connection resets.
 3. Switch over to Termux and run just this command with that current port:
```bash
adb connect 127.0.0.1:[CURRENT_PORT]

```
*(If you are connected to a standard Wi-Fi network, replace 127.0.0.1 with whatever IP address is displaying on your screen, like 192.168.1.52).*
 4. Run adb devices to verify. You'll see it switch to device immediately without asking for a code.
Once that handshake updates, your OpenCode agent will be instantly plugged back into the system layer. Let me know when the link is alive, and we'll have the agent execute that initial **Device ID baseline profile** to our new folder!
