// app.js - Yandex Delivery Express API Demo

/* ----------------------------------------------------------
 * Data model describing each operation, its fields & mock response
 * --------------------------------------------------------*/
const operations = {
  calculateOffers: {
    title: "Calculate Offers",
    description: "Get delivery options and pricing for a shipment.",
    method: "GET",
    endpoint: "/courier/v1/offer/calculate",
    required: [
      { name: "pickup_address", label: "Pickup Address", type: "text" },
      { name: "delivery_address", label: "Delivery Address", type: "text" },
      { name: "weight", label: "Weight (kg)", type: "number", step: "0.1" }
    ],
    optional: [
      { name: "length", label: "Length (cm)", type: "number" },
      { name: "width", label: "Width (cm)", type: "number" },
      { name: "height", label: "Height (cm)", type: "number" },
      { name: "comment", label: "Comment", type: "text" }
    ],
    mockResponse: {
      offers: [
        {
          offer_id: "123456",
          price: 200.5,
          currency: "RUB",
          delivery_eta_minutes: 45
        }
      ]
    }
  },
  createClaim: {
    title: "Create Claim",
    description: "Submit a new delivery request.",
    method: "POST",
    endpoint: "/courier/v1/claim/create",
    required: [
      { name: "recipient_phone", label: "Recipient Phone", type: "tel" },
      { name: "pickup_address", label: "Pickup Address", type: "text" },
      { name: "delivery_address", label: "Delivery Address", type: "text" }
    ],
    optional: [
      { name: "package_weight", label: "Package Weight (kg)", type: "number", step: "0.1" },
      { name: "package_dimensions", label: "Package Dimensions (LxWxH cm)", type: "text" },
      { name: "comment", label: "Comment", type: "text" }
    ],
    mockResponse: {
      claim_id: "clm_98765432",
      status: "new",
      courier_search_started: false
    }
  },
  getClaimInfo: {
    title: "Get Claim Info",
    description: "Retrieve details about an existing claim.",
    method: "GET",
    endpoint: "/courier/v1/claim/info",
    required: [
      { name: "claim_id", label: "Claim ID", type: "text" }
    ],
    optional: [],
    mockResponse: {
      claim_id: "clm_98765432",
      status: "performing",
      courier: { name: "Ivan", phone: "+79990001122" }
    }
  },
  acceptClaim: {
    title: "Accept Claim",
    description: "Confirm and accept a delivery claim.",
    method: "PUT",
    endpoint: "/courier/v1/claim/accept",
    required: [
      { name: "claim_id", label: "Claim ID", type: "text" }
    ],
    optional: [
      { name: "version", label: "Claim Version (integer)", type: "number" }
    ],
    mockResponse: {
      claim_id: "clm_98765432",
      status: "accepted"
    }
  },
  cancelClaim: {
    title: "Cancel Claim",
    description: "Cancel an existing delivery claim.",
    method: "DELETE",
    endpoint: "/courier/v1/claim/cancel",
    required: [
      { name: "claim_id", label: "Claim ID", type: "text" }
    ],
    optional: [
      { name: "cancel_state", label: "Cancel State (free/paid)", type: "text" },
      { name: "version", label: "Claim Version (integer)", type: "number" }
    ],
    mockResponse: {
      claim_id: "clm_98765432",
      status: "cancelled",
      cancel_state: "free"
    }
  }
};

/* ----------------------------------------------------------
 * Helper functions
 * --------------------------------------------------------*/
function $(selector, scope = document) {
  return scope.querySelector(selector);
}

function createElement(tag, attrs = {}, children = []) {
  const el = document.createElement(tag);
  Object.entries(attrs).forEach(([key, value]) => {
    if (key === "class") {
      el.className = value;
    } else if (key === "text") {
      el.textContent = value;
    } else {
      el.setAttribute(key, value);
    }
  });
  children.forEach(child => el.appendChild(child));
  return el;
}

/* ----------------------------------------------------------
 * DOM Elements - initialized after DOM is ready
 * --------------------------------------------------------*/
let homeView, formView, backButton, formTitle, formDescription, formFieldsWrapper, apiForm, resetFormBtn, requestDisplay, responseDisplay, requestJsonEl, responseJsonEl;

/* ----------------------------------------------------------
 * Navigation actions
 * --------------------------------------------------------*/
function navigateHome() {
  console.log("Navigating to home");
  formView.classList.add("hidden");
  homeView.classList.remove("hidden");
  backButton.classList.add("hidden");
}

/* ----------------------------------------------------------
 * Form rendering logic
 * --------------------------------------------------------*/
function renderFields(fieldArray, container) {
  const fragment = document.createDocumentFragment();
  fieldArray.forEach(field => {
    const fieldGroup = createElement("div", { class: "form-group" });

    const label = createElement("label", {
      class: "form-label",
      for: field.name,
      text: field.label
    });

    const input = createElement("input", {
      class: "form-control",
      id: field.name,
      name: field.name,
      type: field.type || "text"
    });
    if (field.step) input.setAttribute("step", field.step);

    fieldGroup.appendChild(label);
    fieldGroup.appendChild(input);
    fragment.appendChild(fieldGroup);
  });
  container.appendChild(fragment);
}

function showForm(operationKey) {
  console.log("Showing form for operation:", operationKey);
  const op = operations[operationKey];
  if (!op) return;

  // Reset previous form state
  apiForm.reset();
  formFieldsWrapper.innerHTML = "";
  requestDisplay.classList.add("hidden");
  responseDisplay.classList.add("hidden");

  formTitle.textContent = op.title;
  formDescription.textContent = op.description;

  // Required fields header
  const reqHeader = createElement("h3", { text: "Required Parameters" });
  formFieldsWrapper.appendChild(reqHeader);
  renderFields(op.required, formFieldsWrapper);

  // Optional fields section
  if (op.optional && op.optional.length > 0) {
    const detailsEl = createElement("details", { class: "optional-details" });
    const summaryEl = createElement("summary", { text: "Optional Parameters" });
    detailsEl.appendChild(summaryEl);

    const optionalWrapper = createElement("div");
    renderFields(op.optional, optionalWrapper);
    detailsEl.appendChild(optionalWrapper);
    formFieldsWrapper.appendChild(detailsEl);
  }

  // Store current operation on form element for later reference
  apiForm.dataset.opKey = operationKey;

  // Switch views
  homeView.classList.add("hidden");
  formView.classList.remove("hidden");
  backButton.classList.remove("hidden");
}

/* ----------------------------------------------------------
 * Form submission logic
 * --------------------------------------------------------*/
function handleFormSubmit(e) {
  e.preventDefault();
  console.log("Form submitted");

  const opKey = apiForm.dataset.opKey;
  const op = operations[opKey];
  if (!op) return;

  const formData = new FormData(apiForm);
  const payload = {};
  formData.forEach((value, key) => {
    if (value !== "") {
      // Convert number fields to actual numbers
      const field = [...op.required, ...op.optional].find(f => f.name === key);
      if (field && field.type === "number") {
        payload[key] = parseFloat(value);
      } else {
        payload[key] = value;
      }
    }
  });

  // Display request JSON
  const requestData = {
    method: op.method,
    endpoint: op.endpoint,
    payload: payload
  };
  
  requestJsonEl.textContent = JSON.stringify(requestData, null, 2);
  requestDisplay.classList.remove("hidden");

  // Show loading in response
  responseJsonEl.textContent = "Loading...";
  responseDisplay.classList.remove("hidden");

  // Simulate API call with timeout
  setTimeout(() => {
    responseJsonEl.textContent = JSON.stringify(op.mockResponse, null, 2);
    console.log("Response displayed");
  }, 600);
}

function handleResetForm() {
  console.log("Resetting form");
  apiForm.reset();
  requestDisplay.classList.add("hidden");
  responseDisplay.classList.add("hidden");
}

/* ----------------------------------------------------------
 * Initialize app after DOM is ready
 * --------------------------------------------------------*/
document.addEventListener("DOMContentLoaded", function() {
  console.log("DOM loaded, initializing app");
  
  // Initialize DOM elements
  homeView = document.getElementById("homeView");
  formView = document.getElementById("formView");
  backButton = document.getElementById("backButton");
  formTitle = document.getElementById("formTitle");
  formDescription = document.getElementById("formDescription");
  formFieldsWrapper = document.getElementById("formFields");
  apiForm = document.getElementById("apiForm");
  resetFormBtn = document.getElementById("resetForm");
  requestDisplay = document.getElementById("requestDisplay");
  responseDisplay = document.getElementById("responseDisplay");
  requestJsonEl = document.getElementById("requestJson");
  responseJsonEl = document.getElementById("responseJson");

  // Verify all elements exist
  if (!homeView || !formView || !backButton || !apiForm) {
    console.error("Critical DOM elements missing");
    return;
  }

  // Set up navigation
  backButton.addEventListener("click", function(e) {
    e.preventDefault();
    navigateHome();
  });

  // Set up operation cards
  document.querySelectorAll(".operation-card").forEach(card => {
    card.addEventListener("click", function(e) {
      e.preventDefault();
      const opKey = card.dataset.operation;
      console.log("Card clicked:", opKey);
      showForm(opKey);
    });
  });

  // Set up form handlers
  apiForm.addEventListener("submit", handleFormSubmit);
  resetFormBtn.addEventListener("click", handleResetForm);
  
  console.log("App initialized successfully");
});