# Inside Out
## An Application Centric Approach to Software Development

What's the biggest mistake you can make when starting a software project?

No, seriously, what's the biggest mistake you've ever made?

The most frequent answer I get to this question is related to requirements. But, having written software in iterative increments for two decades, I am accustomed to changing requirements. In fact, I welcome it. So, not having all the requirements up front is not the biggest possible mistake.

For me, the number one biggest mistake I make when starting a new project is this:

```
$ rails new
```
Not because of Rails. I love Rails. I am more productive in Rails than in any other web framework I've tried. And, I've made a comfortable living off Rails for the better part of the last decade.

Rails isn't the mistake. Starting with a framework is the mistake. It could be any framework: ASP.Net, Laravel, Django, Express, Spring. It doesn't matter which framework. They all make a bunch of decisions for you — before you've even thought about your application.

Now, DHH would argue that's a good thing. Frameworks make many small decisions for you, to free you up to focus on the big decisions — like Steve Job's wardrobe. And, he'd be right.

But, what should your business logic look like?

Rails cannot answer that. No framework can, because your business logic is the one part of your application that is uniquely yours. You should treat it as such. You should shower it with tests. And, you should give it a special home at the center of your application.

The consequence of not treating your business logic as a first class citizen is that it will end up spread all over your application, usually landing in all the spots the framework makes available to you, like models and controllers (and even views!). That's a one way ticket to massive objects that are loosely cohesive and tightly coupled, exactly the opposite of what SOLID object oriented principles teach.

I've personally seen a 10,000 line model with over 700 methods, and a [flog](https://github.com/seattlerb/flog) of over 12,000. I've also seen a 15,000 line controller with over 400 methods, and a flog of over 28,000. These are not classes. They are entire applications in a single file. They're also the antithesis of what the OO community preaches.

*  [Sandi Metz](https://github.com/skmetz), who wrote _Practical Object Oriented Design in Ruby_, has rules for object oriented development. The first two rules say that a class can have no more that 100 lines of code, a method no more than 5.

* In his book, _Working Effectively with Legacy Code_, Michael Feathers says, "In nearly every OO application there’s at least one large class. By large, I mean a class that has 15 or more methods."

* Martin Fowler, who literally wrote the book on _Refactoring_ among many others, including _Patterns of Enterprise Application Architecture_, said on his blog, "Any function more than half-a-dozen lines of code starts to smell to me, and it's not unusual for me to have functions that are a single line of code."

So, if starting with a framework leads to bloated, unweildy software, and the consensus among veteran object oriented specialists is that smaller is better, where should we start?

I believe we should start with our business logic and work from the inside out.

## In this Repo

This repo contains specs for and two implementations of an imaginary Weather Alerting System. The program aggregates weather information from RSS and Twitter feeds, and notifies subscribers of any "active" alerts via SMS, Email, or Messenger. Both implementations pass the same spec file. Their behavior is identical. But, the code is organized differently.

In the `framework-centric` implementation, the code is naïvely put in a controller. As the program grows in complexity, so does the method, ending up with a flog score of 82.3 and a cyclomatic complexity of 12.

The `application-centric` code is organized around principles from Alistair Cockburn's Hexagonal Architecture and Eric Evans' _Domain Driven Design_. The classes are very small. Most methods are a single line of code. Abstractions are used heavily. The average flog score of the methods in the application is 5.2, with a high of 14.7 and a maximum cyclomatic complexity of 5.

Code in the repo is organized by feature. Check out the commit messages to compare the complexity of each implementation over time.

Also, the `lib` folder contains stubs for classes that would likely be identical across both applications. Most would likely come from gems.

## Conclusion

Overall, the framework-centric approach is smaller and less complex in the whole. But, application-centric implementation has a considerably smaller average method complexity and a lower maximum number of code paths.

What this says to me is that small, simple applications are likely good candidates for the framework-centric approach. But, that larger, more complex applications would benefit substantially from taking an inside out, application-centric approach.

The Weather Alerting System is currently so small, that it makes sense to go with the more procedural framework-centric method. If the application were to grow substantially, there would likely come an inflection point at which it makes more sense to go with the application centric approach.

## Resources

Read these books!

<img src="https://prodimage.images-bn.com/pimages/9780321721334_p0_v2_s600x595.jpg" width="100" style="margin: 20px; width: 100px"> <img src="https://prodimage.images-bn.com/pimages/9780131177055_p0_v2_s600x595.jpg" width="100" style="margin: 20px; width: 100px"> <img src="https://prodimage.images-bn.com/pimages/9780133065268_p0_v1_s600x595.jpg" width="100" style="margin: 20px; width: 100px"> <img src="https://prodimage.images-bn.com/pimages/9780321127426_p0_v2_s600x595.jpg" width="100" style="margin: 20px; width: 100px">

* [Practical Object Oriented Design in Ruby](https://www.barnesandnoble.com/w/practical-object-oriented-design-in-ruby-sandi-metz/1119329331?ean=9780321721334) by Sandi Metz
* [Working Effectively with Legacy Code](https://www.barnesandnoble.com/w/working-effectively-with-legacy-code-michael-feathers/1101414704?ean=9780131177055) by Michael Feathers
* [Refactoring](https://www.barnesandnoble.com/w/refactoring-martin-fowler/1100891641?ean=9780133065268) by Martin Fowler
* [Patterns of Enterprice Application Architecture](https://www.barnesandnoble.com/w/patterns-of-enterprise-application-architecture-martin-fowler/1126009522?ean=9780321127426) by Martin Fowler

There are two metrics mentioned in the commit messages: flog and cyclomatic complexity.

Flog measures how easy a program is to understand. The higher the number, the more complex the method or class. It is a good proxy for how difficult it would be to hold all the context of that particular bit of code in your head at one time.

Cyclomatic complexity is a measure of the number of code paths through a method. If a method has a single if statement, there are 2 code paths. If you add another case statement with three branches after the if statement, there would be 6 code paths. The more code paths there are in a method, the harder it is to test.

