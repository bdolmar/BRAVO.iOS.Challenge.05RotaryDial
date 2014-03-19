This is the next challenge of a new series of activities. The goal of this series of challenges is to give developers a chance to explore portions of the API that have a discrete, small scope and that are likely to be less understood.

The requirements for the challenge are as follows:

 1. Create a dial. The dial represents a value between 1 and 100.
 2. The dial should include a drag handle. When a user drags the the drag handle the dial should orient to track the user's dragging gesture. Only when the user drags on the drag handle should the dial turn.
 3. The dial should also include two touchable regions. If you touch the region, counter-clockwise from handle the dial should orient itself to the nearest step on the circle that is a whole 12th of the circle in that direction. For example, if the dial were to be imagined as a clock and the minute hand was on 37 minutes after the hour, tapping that region would move the minute hand to 35 minutes after the hour. Touching it again at that point would move it to 30 minutes after the hour.
 4. Touching the region clockwise from the handle moves the dial in a similar fashion, but in the clockwise direction.
 5. When the dial's value updates, display the current value of the dial in a UILabel on the screen. Round that value to the nearest whole number.
 
Sample images for the specific hit areas have been included with the sample project. It is expected that hits will only register in the bounds of the ring, not in the whole rectangular bounds of the images. The final assembled dial should look like the following:

![Dial Sample Image](https://raw.github.com/bdolmar/BRAVO.iOS.Challenge.05RotaryDial/master/ArtAssets/DialComponents.png)

I'm making a contest of the challenge. Entries will be accepted until 4/11/2014. All entries will be evaluated by Ben Dolmar and the best challenge will be announced at the next iOS Talk Shop and win a free lunch. If I judge a tie to have occurred, I'll raffle the lunch. In addition, I'll post my solution to the problem on that Friday and include an artilc explaining how I approached the problem.

To submit an entry for evaluation, please do the following:

1. Fork the project from https://github.com/bdolmar/BRAVO.iOS.Challenge.05RotaryDial.
2. Post your files to your public fork on Github.
3. Send a pull request back to the original repository with your project by midnight on 4/11/2014