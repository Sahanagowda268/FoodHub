<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.foodhub.DAOImpl.RestaurantDAOImpl, com.foodhub.DAOImpl.MenuDAOImpl, com.foodhub.model.Restaurant, com.foodhub.model.Menu" %>
<style>
/* Chatbot Button */
#chat-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background-color: var(--primary);
    color: white;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 28px;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(107, 58, 91, 0.3);
    z-index: 9999;
    transition: transform 0.3s ease;
}
#chat-btn:hover {
    transform: scale(1.1);
}

/* Chatbot Window */
#chat-window {
    position: fixed;
    bottom: 100px;
    right: 30px;
    width: 350px;
    max-height: 500px;
    background: var(--card);
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    display: none;
    flex-direction: column;
    z-index: 9999;
    overflow: hidden;
    border: 1px solid var(--border);
}

#chat-header {
    background: var(--primary);
    color: white;
    padding: 15px 20px;
    font-weight: 600;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
#chat-close {
    cursor: pointer;
    font-size: 20px;
}

#chat-body {
    padding: 15px;
    flex-grow: 1;
    overflow-y: auto;
    height: 300px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    background: #F8F3F6; /* very subtle plum tint */
}

.chat-msg {
    max-width: 80%;
    padding: 10px 15px;
    border-radius: 18px;
    font-size: 14px;
    line-height: 1.4;
}

.chat-msg.bot {
    background: white;
    color: var(--text);
    align-self: flex-start;
    border-bottom-left-radius: 4px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.chat-msg.user {
    background: var(--secondary);
    color: white;
    align-self: flex-end;
    border-bottom-right-radius: 4px;
}

.chat-quick-replies {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 10px;
}
.chat-quick-btn {
    background: var(--card);
    border: 1px solid var(--secondary);
    color: var(--secondary);
    padding: 6px 12px;
    border-radius: 15px;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.2s;
}
.chat-quick-btn:hover {
    background: var(--secondary);
    color: white;
}

#chat-footer {
    display: flex;
    padding: 10px;
    border-top: 1px solid var(--border);
    background: white;
}
#chat-input {
    flex-grow: 1;
    border: none;
    padding: 10px;
    outline: none;
    font-size: 14px;
}
#chat-send {
    background: none;
    border: none;
    color: var(--primary);
    font-size: 20px;
    cursor: pointer;
    padding: 0 10px;
}
</style>

<div id="chat-btn" onclick="toggleChat()">💬</div>

<div id="chat-window">
    <div id="chat-header">
        <span>FoodHub Assistant</span>
        <span id="chat-close" onclick="toggleChat()">✖</span>
    </div>
    <div id="chat-body">
        <div class="chat-msg bot">
            Hi! 👋 I'm your FoodHub Assistant.<br>Type "hi" to see our restaurants, or ask me anything!
        </div>
    </div>
    <div id="chat-footer">
        <input type="text" id="chat-input" placeholder="Type a message..." onkeypress="handleKeyPress(event)">
        <button id="chat-send" onclick="sendMessage()">➤</button>
    </div>
</div>

<script>
    // Build JSON data on the server side
    const dbRestaurants = {
    <%
        try {
            RestaurantDAOImpl rDao = new RestaurantDAOImpl();
            MenuDAOImpl mDao = new MenuDAOImpl();
            List<Restaurant> allR = rDao.getAllRestaurants();
            if (allR != null) {
                for(int i=0; i<allR.size(); i++) {
                    Restaurant r = allR.get(i);
                    out.print("\"" + r.getRestaurantId() + "\": {");
                    out.print("name: \"" + r.getName().replace("\"", "\\\"") + "\", ");
                    out.print("menus: [");
                    List<Menu> menus = mDao.getMenusByRestaurant(r.getRestaurantId());
                    if (menus != null) {
                        for(int j=0; j<menus.size(); j++) {
                            Menu m = menus.get(j);
                            out.print("{ name: \"" + m.getItemName().replace("\"", "\\\"") + "\", price: " + m.getPrice() + " }");
                            if (j < menus.size() - 1) out.print(",");
                        }
                    }
                    out.print("]");
                    out.print("}");
                    if (i < allR.size() - 1) out.print(",");
                }
            }
        } catch(Exception e) {
            // handle error silently in JS
        }
    %>
    };

    function toggleChat() {
        const chatWindow = document.getElementById('chat-window');
        chatWindow.style.display = chatWindow.style.display === 'flex' ? 'none' : 'flex';
    }

    function handleKeyPress(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    }

    function sendQuickReply(text, restaurantId = null) {
        document.getElementById('chat-input').value = text;
        sendMessage(restaurantId);
    }

    function sendMessage(restaurantId = null) {
        const input = document.getElementById('chat-input');
        const message = input.value.trim();
        if (!message) return;

        appendMessage('user', message);
        input.value = '';

        setTimeout(() => {
            let response = "";
            if (restaurantId && dbRestaurants[restaurantId]) {
                response = generateMenuResponse(restaurantId);
            } else {
                response = getBotResponse(message.toLowerCase());
            }
            appendMessage('bot', response);
        }, 500);
    }

    function appendMessage(sender, text) {
        const body = document.getElementById('chat-body');
        const msgDiv = document.createElement('div');
        msgDiv.className = 'chat-msg ' + sender;
        msgDiv.innerHTML = text;
        body.appendChild(msgDiv);
        body.scrollTop = body.scrollHeight;
    }

    function generateMenuResponse(restaurantId) {
        const r = dbRestaurants[restaurantId];
        if (!r || !r.menus || r.menus.length === 0) return "Sorry, no menus available for " + (r ? r.name : "this restaurant") + " yet.";
        
        let html = `<b>\${r.name} Menu:</b><br><ul style="margin: 5px 0; padding-left: 20px; font-size:13px;">`;
        r.menus.forEach(m => {
            html += `<li>\${m.name} - ₹\${m.price}</li>`;
        });
        html += `</ul>`;
        
        const randomItem = r.menus[Math.floor(Math.random() * r.menus.length)];
        html += `<br><i>💡 I highly suggest you try the <b>\${randomItem.name}</b> today!</i>`;
        
        return html;
    }

    function getBotResponse(input) {
        if (input === 'hi' || input === 'hello' || input === 'hey') {
            let resHtml = "Hi! 👋 Welcome to FoodHub!<br>Here are our amazing restaurants. Click one to see its menu:<br><div class='chat-quick-replies'>";
            for (const key in dbRestaurants) {
                resHtml += `<button class='chat-quick-btn' onclick='sendQuickReply("Show menu for \${dbRestaurants[key].name}", "\${key}")'>🍴 \${dbRestaurants[key].name}</button>`;
            }
            resHtml += "</div>";
            return resHtml;
        }

        // Check if user manually typed a restaurant name
        for (const key in dbRestaurants) {
            if (input.includes(dbRestaurants[key].name.toLowerCase())) {
                return generateMenuResponse(key);
            }
        }

        if (input.includes('register') || input.includes('signup')) {
            return "Click 'Register' in the top navigation bar to create a new account.";
        } else if (input.includes('login') || input.includes('sign in')) {
            return "Click 'Login' in the top navigation bar to access your account.";
        } else if (input.includes('cart') || input.includes('quantity') || input.includes('remove')) {
            return "Click 'Cart 🛒' in the navbar to view your cart. You can change quantities using the + and - buttons, or click Remove to delete an item.";
        } else if (input.includes('favourite') || input.includes('favorite') || input.includes('heart')) {
            return "Click the ❤️ icon on any menu item to add it to your favourites!";
        } else if (input.includes('checkout') || input.includes('delivery') || input.includes('address')) {
            return "Go to your Cart and click 'Proceed to Delivery Location' to choose your address, then place your order on the Checkout page.";
        } else if (input.includes('restaurant') || input.includes('food') || input.includes('menu')) {
            return "Say 'hi' to see a list of our restaurants, or click 'Restaurants' in the top navigation bar!";
        } else if (input.includes('order') || input.includes('orders')) {
            return "Once you select your delivery address and payment method in Checkout, click 'Place Order' to finalize it.";
        } else if (input.includes('profile') || input.includes('account') || input.includes('edit')) {
            return "Click 'Profile 👤' in the top navigation bar to view your details, then click 'Edit Profile' to update your information.";
        } else {
            return "I'm not sure how to help with that. Try saying 'hi' to see our restaurants, or ask about your cart, checkout, or editing your profile!";
        }
    }
</script>
