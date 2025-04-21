// Script principal pour le portail de recrutement

document.addEventListener('DOMContentLoaded', function() {
    // Animation des messages flash
    let alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            let bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000); // Fermer automatiquement les alertes après 5 secondes
    });

    // Validation côté client pour le formulaire de candidature
    const applicationForm = document.querySelector('form');
    if (applicationForm) {
        applicationForm.addEventListener('submit', function(event) {
            let valid = true;
            
            // Vérifier les champs obligatoires
            const requiredFields = applicationForm.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    valid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            
            // Vérifier le format de l'email
            const emailField = applicationForm.querySelector('input[type="email"]');
            if (emailField && emailField.value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(emailField.value)) {
                    emailField.classList.add('is-invalid');
                    valid = false;
                }
            }
            
            // Vérifier l'extension du fichier CV
            const cvField = applicationForm.querySelector('input[type="file"]');
            if (cvField && cvField.files.length > 0) {
                const fileName = cvField.files[0].name;
                if (!fileName.toLowerCase().endsWith('.pdf')) {
                    cvField.classList.add('is-invalid');
                    valid = false;
                    
                    // Créer un message d'erreur s'il n'existe pas déjà
                    let errorMsg = cvField.nextElementSibling;
                    if (!errorMsg || !errorMsg.classList.contains('invalid-feedback')) {
                        errorMsg = document.createElement('div');
                        errorMsg.classList.add('invalid-feedback');
                        errorMsg.textContent = 'Le fichier doit être au format PDF';
                        cvField.parentNode.insertBefore(errorMsg, cvField.nextSibling);
                    }
                }
            }
            
            if (!valid) {
                event.preventDefault();
                // Scroll vers le premier champ invalide
                const firstInvalid = applicationForm.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
            }
        });
        
        // Réinitialiser la validation lors de la saisie
        applicationForm.querySelectorAll('input, textarea, select').forEach(element => {
            element.addEventListener('input', function() {
                this.classList.remove('is-invalid');
            });
        });
    }
    
    // Animation pour les cartes d'offres d'emploi
    const jobCards = document.querySelectorAll('.card');
    if (jobCards.length > 0) {
        jobCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px)';
                this.style.boxShadow = '0 15px 30px rgba(0, 0, 0, 0.1)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.08)';
            });
        });
    }
});
