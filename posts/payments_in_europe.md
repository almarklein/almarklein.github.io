# What I learned about collecting payments for digital goods in Europe

<!-- DATE: 2021-08-03 -->
<!-- TAGS: web -->
<!-- AUTHOR: Almar -->

Selling (digital) products internationally is hard because of the complicated VAT rules. Fortunately there are services (MOR's) that make it easy to collect payments. 

<!-- END_SUMMARY -->


![A collection of globes and spheres](images/globes.jpg)
<br /><small><i>
Image via maxpixel (CC0 public domain)
</i></small>

----


Creating and selling digital products can be a viable way for a software developer to generate income. These can vary from licenses, SaaS producs, books, art, and more. Some people try this approach to monetize an idea that they have. For others it may be a way to make an existing (Open Source) project more sustainable. And then there's people who just generate a spree of ideas and prototypes until one catches on.

A few years ago I tried my luck creating a [time tracking app](https://timetagger.app). I'm a developer at heart, and oh my, how have I underestimated the amount of work that comes *after* the app is technically finished. I've learned a lot in that time. For the most part it felt like I learned things that every [indie hacker](https://www.indiehackers.com) goes through. But one thing stood out because it looks like few people know this: how to collect payments in the legally correct way without going crazy.

Among the many things that I learned is how to collect payments, and how that differs depending on where you live. Cause it turns out things are more complicated if you're in the EU.

## Why accepting payments is hard: VAT

I should probably start by saying that I'm not a lawyer. Don't take any of this as legal advice.

Whenever you sell a product, in most countries you have to charge a certain percentage of VAT, which you later pay to the tax office. If you sell products in your own country, the rules are simple.

Things become a lot more complicated if the buyer and seller are not (based) in the same country. The tax that needs to be charged for a product depends on the location of both the seller and buyer, and the laws applicable in the respective countries. I'm pretty sure many small online businesses pretend that all clients are from their own country. Or similarly, a seller in Europe might pretend that all sales are outside of the EU. They may get away with it, but it's probably not legally correct.

If you are a seller based in the European Union, you need to charge the VAT applicable to the buyer's country of residence. (Or is it the country that the buyers is in at the moment of the purpose? I'm not even sure.) In other words, you'll have to treat the VAT differently for each country you have costumers in, and you need to pay taxes in the respective countries. Some countries exempt you from having to do so if the total profit is below a threshold. Still ... good luck figuring all that out ...

## Payments as a service

There are many companies that offer the service of handling your customer payments and related tasks. It took me a while to realize how these companies differ. For instance, Stripe is very popular with people running a SaaS right now. But it turns out that it's not very well suited if you run your SaaS from the EU - unless you like dealing with complex tax rules.

Here's what I learned about the different payment services that exist. As it turns out, the different payment service companies can be roughly divided into three categories:


### The payment gateways

[Payment gateways](https://en.wikipedia.org/wiki/Payment_gateway) provide the service of handling a payment. They may offer a wide range of payment methods, like credit card, Paypal, bank transfer and sometimes even cash. There may also be region-specific methods like e.g. SEPA and IDeal in the EU. The costs for using such a service is usually calculated per transaction, in the order of 30 ct plus 5%.

Some examples:

* Stripe is a well known payment gateway based in the US. They are praised for their simple interface and powerful API.
* Mollie is a payment gateway in the EU, also with a solid API, and offering payment methods specific to EU countries.

### The invoicing services

Some companies focus on handling the invoicing of your customers. They will make sure that the invoice has the right amount of VAT on it. They will usually provide you with a report that you can use to register (and pay) the taxes. Note that these taxes can apply to multiple different countries.
Some of these services are aimed at subscriptions (recurring payments) that you can manage via their interface, and the service company will make sure that the payments are done, retry failed payments etc.

These services sit it between you and the payment gateway. Usually such a service will support multiple gateways, and sometimes it may have its own payment gateway.

The costs for such a service depends on the company. Some companies ask a monthly fee, while with others you pay per transaction.

Some examples:

* Stripe Billing is a product within Stripe that helps with recurrent payments.
* Recurring is a side-product of Mollie to handle subscriptions.
* ChargeBee offers invoicing and subscription models.

### The merchants of record

In all of the above situations, you are selling a product to your customers, and these services help with that. But in the end *you* are the seller, and *you* are responsible (and liable) for charging the right amount of tax, and for registering the taxes in the appropriate countries.

But what if you're not the seller? The third group of companies *re-sell* your product. Thereby they act as the merchant of record (or MOR, for short), and take on the responsibility for handling the payment, charging the right amount of VAT, and regsitering/paying the taxes in the appropriate countries. The only transaction that you have to "worry about" is the weekly/monhtly payout with that company.

The costs for this service are usually an extra fee per transaction, sometimes in combination with a monhtly fee.

The companies that I am aware that offer this service:

* [GumRoad](https://gumroad.com/), aiming for creators ranging from artists and authors to programmers. Their user interface has a "creators vibe". There is an API, but it could be better. Their pricing is fair.
* [Paddle](https://paddle.com/), aiming for a more professional look and feel, has slick checkout pages, and an ok API. They charge 50ct + 5% per transaction.
* [FastSpring](https://fastspring.com) is probably the most complete in terms of features, but personally I found the UI rather complex. I have not been able to find the pricing.
* [AboWire](https://abowire.com) is a EU-based startup. Other than the above three, it also support EU-specific payment gateways!

*If you know of any other MOR companies, please let me know and I'll update this list!*

## MOSS

A solution that deserves being mentioned here is the MOSS. If you are in the EU, all your clients are in the EU, all your clients are private persons, and you sell digital products ... you may be eligible for Mini One Stop Shop (MOSS). This allows you to account for VAT in just a single country. That's a lot of if's and because it's restricted to clients within the EU I have not looked into this much deeper.

## Closing thoughts

Selling digital products is complicated by the international rules on charging VAT. If you're small enough you might get away with ignoring it, but you probably shouldn't. Fortunately there are services that take all the complexities out of the way!

## Links

* [A discussion on the subject on Indie Hackers](https://www.indiehackers.com/post/how-does-your-europe-based-saas-collect-payments-taxes-are-hard-9a829d8d9e) from which I learned a lot.
* [A post by Stefan Bauer on the subject](https://stefanbauer.me/articles/the-hell-of-taxes-when-building-a-saas-in-europe) that clarifies a lot.

