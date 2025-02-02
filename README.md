<img src=resources/misc/hero_image.png width="100%">

# ROcalendar 2025

> [!IMPORTANT] 
> This works only for the 2025 year

ROcalendar is an app made for garmin watches (with 5 buttons). 

This will display all the events that are part of the Cristian Ortodox Calendar + Public Hollidays in Romania

The app supports 3 event types:
* Public Holidays
* Blue Cross Cristian Ortodox
* Black Cross Cristian Ortodox

> [!TIP] 
> You can use the app by direct sideloading.

# Implementation

### Database
Due to limitations for Connect IQ and memory on device the database needs to be splitted in 2 -> Main one and Glance one

Database consists in a json file for Main and 12 json for glance

### Month View

To accomplish a scroll efect really easy and a dinamic animation was implemented based on keys/swipes

### Views/Delegates

Management of views and delegates for main and month is done with a management component that holds the instances

# Screenshots
Glance View -> Where you can see the next event, type of the event and days untill

<img src=resources/misc/glance_full.png width="200">

Main View -> Where you can see the entire month and some dots for each day type and the current day

<img src=resources/misc/overview_full.png width="200">

Month View -> Where you can see each day in a month with the full name and event type


<img src=resources/misc/month_full.png width="200">

Menu View -> Where you can set colors for each event type

<img src=resources/misc/menu_full.png width="200">

# Improvements that could be done

* Multi-Year
* More details on event
* Notifications/Alerts

# Disclaimer

No aditional features are promised

No update for other years are primised

> [!CAUTION]
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
