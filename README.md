## Project DrDelivery ✈️

#### Problem Statement
<ol type = "1">
<li> Last-mile delivery 📦 is often the most expensive part of any delivery operation. In fact, last mile delivery costs account for <a href = "https://www.businessinsider.com/last-mile-delivery-shipping-explained">💲 53% of total shipping costs 💲</a>. </li>
<li> A report from McKinsey&Company predicts that a future of <a href = "https://www.mckinsey.com/~/media/mckinsey/industries/travel%20transport%20and%20logistics/our%20insights/how%20customer%20dema    nds%20are%20reshaping%20last%20mile%20delivery/parcel_delivery_the_future_of_last_mile.ashx"> 🤖 automated vehicles, with drones being responsible for parcel deliveries 🤖</a>. </li>
<li> Our goal in this project is thus to build a simulation of a drone-centric last-mile delivery network. 🦾 </li>
</ol>

#### Proposal ✍️
<ol type start = "4">
<li> To achieve this, we will build a suite of software products. </li>
<li> Our first product will be the 🌐 Mission Control 🌐. Our idea behind a drone-network is that it will be based on a centralised control which gives out instructions to the drones. The Mission Control is the interface that the logistic company will use to monitor the network. </li>
<li> Our next products will include a bare-skeleton consumer front-facing app (User 👨) and a merchant dashboard (Supplier Dashboard 🤵), which will interact with the Mission Control to simulate real orders. </li> 
<li> The following is a prototype run-down of how our simulation will work:  
  <ol type = "a">
  <li> The user makes an order via the User App</li>
  <li> At this point in time, the merchant can see his order via Supplier Dashboard</li>
  <li> Upon accepting the order, a drone will be dispatched to the merchant, which is reflected from the Mission Control</li>
  <li> The merchant will load the product onto the drone</li>
  <li> The drone will then proceed to the customer’s destination</li>
  <li> Upon arrival, the drone will unload the product</li>
  </ol> </li>
<li> Points i to vi will form our minimum viable product, to achieve by end of this AY 20/21 Summer. 🔥 </li>
</ol>

#### Assumptions ❗
<ol type start = "9">
<li> For this project, we will mainly concern ourselves with the software aspect. We, therefore, assume the following:
<ol type = "i"> 
<li> The merchant and the consumer can handle the loading and unloading of the product from the drone</li>
<li> The drone flight path and the building of the charging stations are approved</li>
<li> Each drone can carry the load of the product</li>
<li> The drone can operate at 100% performance at all times (regardless of weather and drone conditions 🌧️)</li>
</ol> </li>
</ol>

#### Stretch Goals 🥅
<ol type start = "10">
<li> If we achieve the minimum viable product before end of summer, some other goals we could work on include:
<ol type = "a">
<li> Simulating each drone to a battery lifespan parameter, which will be recharged at charging stations </li>
<li> Simulating variable weights of each order and differing drone-carrying capabilities </li>
<li> Simulation of load along the edges (i.e. how many drones can go pass an edge at one time) </li>
<li> Delivery metrics for the logistic company (average waiting time, drone utilisation rate, etc) </li>
</ol> </li>
</ol>

#### Tech Stack ⚙️
<ol type start = "11">
<li> As of now, we intend to use Ruby on Rails, React and Unity to complete this project. </li>
</ol>

#### Prototypes (Done with Figma) 👍
12. [User App](https://www.figma.com/proto/qtblnCuIvE8qbzRdchBQAv/User?node-id=12%3A1299&scaling=scale-down&page-id=0%3A1)
13. [Supplier Dashboard](https://www.figma.com/proto/soNBgJyqtwvGNFrtPCef3P/Supplier-Dashboard?node-id=0%3A3&frame-preset-name=Desktop&scaling=scale-down&page-id=0%3A1)
14. [Mission Control](https://www.figma.com/proto/RcQfwYNX2r5OkIzKkdLsJe/Mission-Control?node-id=3%3A39&scaling=contain&page-id=0%3A1) 
