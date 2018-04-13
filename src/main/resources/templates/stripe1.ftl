<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Stripe</title>

    <style>
    /**
     * The CSS shown here will not be introduced in the Quickstart guide, but shows
     * how you can use CSS to style your Element's container.
     */
    .StripeElement {
      background-color: white;
      padding: 8px 12px;
      border-radius: 4px;
      border: 1px solid transparent;
      box-shadow: 0 1px 3px 0 #e6ebf1;
      -webkit-transition: box-shadow 150ms ease;
      transition: box-shadow 150ms ease;
    }

    .StripeElement--focus {
      box-shadow: 0 1px 3px 0 #cfd7df;
    }

    .StripeElement--invalid {
      border-color: #fa755a;
    }

    .StripeElement--webkit-autofill {
      background-color: #fefde5 !important;
    }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://js.stripe.com/v3/"></script>

</head>
<body>

    <div  class="col-md-12">
        <div class="col-md-1"></div>
        <div class="col-md-3">
            Known Stripe tokens for ${user.getName()}
            <br>
            <#list StripeCreditCardToken.findByUserId(user.getId()) as scct >
                ${scct.getToken()}
                <br>
            </#list>
            <p></p>
        </div>
        <!--4242 4242 4242 4242-->
        <div class="col-md-3">
            <form action="/charge" method="post" id="payment-form">
                <div class="form-row">
                    <label for="card-element">
                        Credit or debit card of ${user.getName()}
                    </label>
                    <div id="card-element">
                        <!-- a Stripe Element will be inserted here. -->
                    </div>

                    <!-- Used to display form errors -->
                    <div id="card-errors" role="alert"></div>
                </div>

                <button>Submit Payment</button>
            </form>
        </div>
        <div class="col-md-6"></div>
    </div>

    <div  class="col-md-12">
        <h4>Charge Card</h4>
        <select id="tokenSelect">
            <#list StripeCreditCardToken.findByUserId(user.getId()) as scct >
                <option value="${scct.getToken()}">${scct.getToken()}</option>
            </#list>
        </select>
        <br>
        <div class="col-md-3">
            <button onclick="chargeCard()">Charge directly to card/token</button>
        </div>
    </div>

    <div  class="col-md-12">
        <h4>Create a Stripe Customer</h4>
        <select id="tokenSelect2">
            <#list StripeCreditCardToken.findByUserId(user.getId()) as scct >
                <option value="${scct.getToken()}">${scct.getToken()}</option>
            </#list>
        </select>
        <br>
        <select id="emailSelect">
            <#list EmailAddress.findByUserId(user.getId()) as email >
                <option value="${email.getEmail()}">${email.getEmail()}</option>
            </#list>
        </select>
        <br>
        <div class="col-md-3">
            <button onclick="createCustomer()">Create customer</button>
        </div>
    </div>

    <div  class="col-md-12">
        <h4>Charge Customer</h4>
        <#if StripeCustomer.findByUserId(user.getId())?? >
            <select id="customerSelect">
                <option value="${StripeCustomer.findByUserId(user.getId()).getStripeCustomerId()}">${StripeCustomer.findByUserId(user.getId()).getStripeCustomerId()}</option>
            </select>
        <br>
            <div class="col-md-3">
                <button onclick="chargeCustomer()">Charge customer</button>
            </div>
        <#else>
            Stripe customer has not been created
        </#if>
    </div>

    <script>
        // Create a Stripe client
        var stripe = Stripe('pk_test_6pRNASCoBOKtIshFeQd4XMUh');

        // Create an instance of Elements
        var elements = stripe.elements();

        // Custom styling can be passed to options when creating an Element.
        // (Note that this demo uses a wider set of styles than the guide below.)
        var style = {
          base: {
            color: '#32325d',
            lineHeight: '24px',
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': {
              color: '#aab7c4'
            }
          },
          invalid: {
            color: '#fa755a',
            iconColor: '#fa755a'
          }
        };

        // Create an instance of the card Element
        var card = elements.create('card', {style: style});

        // Add an instance of the card Element into the `card-element` <div>
        card.mount('#card-element');

        // Handle real-time validation errors from the card Element.
        card.addEventListener('change', function(event) {
          var displayError = document.getElementById('card-errors');
          if (event.error) {
            displayError.textContent = event.error.message;
          } else {
            displayError.textContent = '';
          }
        });

        // Handle form submission
        var form = document.getElementById('payment-form');
        form.addEventListener('submit', function(event) {
          event.preventDefault();

          stripe.createToken(card).then(function(result) {
            if (result.error) {
              // Inform the user if there was an error
              var errorElement = document.getElementById('card-errors');
              errorElement.textContent = result.error.message;
            } else {
              // Send the token to your server
              stripeTokenHandler(result.token);
            }
          });
        });

        // send the Stripe token for this user's card back to server
        function stripeTokenHandler(token) {
            var x = token;
            var url = "/shop-api/stripe?userId=${user.getId()}&action=saveToken&token=" + token.id;
            $.get(url, function(data, status){
                var x = status;
                location.assign("/stripe");
            });
        }

        function chargeCard() {
            var token = document.getElementById('tokenSelect').value;
            var url = "/shop-api/stripe?userId=${user.getId()}&action=chargeCard&token=" + token;
            $.get(url, function(data, status){
                var x = status;
                location.assign("/stripe");
            });
        }

        function createCustomer() {
            var token = document.getElementById('tokenSelect2').value;
            var email = document.getElementById('emailSelect').value;
            var url = "/shop-api/stripe?userId=${user.getId()}&action=createCustomer&token=" + token
                    + "&email=" + email;
            $.get(url, function(data, status){
                var x = status;
                location.assign("/stripe");
            });
        }

        function chargeCustomer() {
            var id = document.getElementById('customerSelect').value;
            var url = "/shop-api/stripe?userId=${user.getId()}&action=chargeCustomer&token=&customerId=" + id;
            $.get(url, function(data, status){
                var x = status;
                location.assign("/stripe");
            });
        }
    </script>
</body>
</html>


