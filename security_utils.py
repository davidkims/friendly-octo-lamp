#!/usr/bin/env python3
"""
Security utilities for the Friendly Octo Lamp application
Demonstrates secure coding practices for CodeQL analysis
"""

import hashlib
import secrets
import re
from typing import Optional, Dict, Any
import logging
from datetime import datetime, timedelta

# Setup secure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class SecurityUtils:
    """Utility class for security operations"""
    
    def __init__(self):
        self.salt_length = 32
        self.hash_iterations = 100000
    
    def generate_secure_token(self, length: int = 32) -> str:
        """Generate a cryptographically secure random token"""
        if length < 16:
            raise ValueError("Token length must be at least 16 characters")
        return secrets.token_urlsafe(length)
    
    def hash_password(self, password: str, salt: Optional[bytes] = None) -> tuple:
        """
        Hash a password using PBKDF2 with SHA-256
        Returns (hashed_password, salt) tuple
        """
        if len(password) < 8:
            raise ValueError("Password must be at least 8 characters long")
        
        if salt is None:
            salt = secrets.token_bytes(self.salt_length)
        
        # Use PBKDF2 for secure password hashing
        hashed = hashlib.pbkdf2_hmac(
            'sha256',
            password.encode('utf-8'),
            salt,
            self.hash_iterations
        )
        
        return hashed.hex(), salt.hex()
    
    def verify_password(self, password: str, hashed_password: str, salt: str) -> bool:
        """Verify a password against its hash"""
        try:
            salt_bytes = bytes.fromhex(salt)
            expected_hash, _ = self.hash_password(password, salt_bytes)
            return secrets.compare_digest(expected_hash, hashed_password)
        except (ValueError, TypeError):
            return False
    
    def sanitize_input(self, user_input: str) -> str:
        """Sanitize user input to prevent injection attacks"""
        if not isinstance(user_input, str):
            raise TypeError("Input must be a string")
        
        # Remove potential dangerous characters
        sanitized = re.sub(r'[<>"\';\\]', '', user_input)
        
        # Limit length
        sanitized = sanitized[:1000]
        
        # Strip whitespace
        sanitized = sanitized.strip()
        
        return sanitized
    
    def validate_email(self, email: str) -> bool:
        """Validate email format"""
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(email_pattern, email))
    
    def generate_session_id(self) -> str:
        """Generate a secure session identifier"""
        return self.generate_secure_token(64)
    
    def is_session_expired(self, created_time: datetime, max_age_hours: int = 24) -> bool:
        """Check if a session has expired"""
        expiry_time = created_time + timedelta(hours=max_age_hours)
        return datetime.utcnow() > expiry_time

class InputValidator:
    """Input validation utilities"""
    
    @staticmethod
    def validate_api_key(api_key: str) -> bool:
        """Validate API key format"""
        if not isinstance(api_key, str):
            return False
        
        # API key should be alphanumeric and of specific length
        if len(api_key) != 32:
            return False
        
        return api_key.isalnum()
    
    @staticmethod
    def validate_user_data(data: Dict[str, Any]) -> Dict[str, str]:
        """Validate user data and return errors if any"""
        errors = {}
        
        # Check required fields
        required_fields = ['username', 'email']
        for field in required_fields:
            if field not in data or not data[field]:
                errors[field] = f"{field} is required"
        
        # Validate email format
        if 'email' in data and data['email']:
            if not SecurityUtils().validate_email(data['email']):
                errors['email'] = "Invalid email format"
        
        # Validate username
        if 'username' in data and data['username']:
            username = data['username']
            if len(username) < 3 or len(username) > 50:
                errors['username'] = "Username must be between 3 and 50 characters"
            
            if not re.match(r'^[a-zA-Z0-9_]+$', username):
                errors['username'] = "Username can only contain letters, numbers, and underscores"
        
        return errors

def secure_log_event(event_type: str, user_id: Optional[str] = None, 
                    metadata: Optional[Dict[str, Any]] = None):
    """Securely log events without exposing sensitive data"""
    
    # Create safe log entry
    log_entry = {
        'timestamp': datetime.utcnow().isoformat(),
        'event_type': event_type,
        'user_id': user_id[:8] + '...' if user_id and len(user_id) > 8 else user_id,
        'metadata': {}
    }
    
    # Filter sensitive data from metadata
    if metadata:
        safe_keys = ['action', 'resource', 'status', 'ip_hash']
        for key in safe_keys:
            if key in metadata:
                log_entry['metadata'][key] = metadata[key]
    
    logger.info(f"Security Event: {log_entry}")

def main():
    """Demo the security utilities"""
    print("🛡️ Security Utilities Demo")
    
    # Initialize security utils
    security = SecurityUtils()
    validator = InputValidator()
    
    # Generate secure token
    token = security.generate_secure_token()
    print(f"Generated secure token: {token[:16]}...")
    
    # Hash a password
    password = "secure_password_123"
    hashed_pwd, salt = security.hash_password(password)
    print(f"Password hashed successfully")
    
    # Verify password
    is_valid = security.verify_password(password, hashed_pwd, salt)
    print(f"Password verification: {'✅' if is_valid else '❌'}")
    
    # Sanitize input
    dangerous_input = "<script>alert('xss')</script>user@example.com"
    safe_input = security.sanitize_input(dangerous_input)
    print(f"Sanitized input: {safe_input}")
    
    # Validate email
    email_valid = security.validate_email("user@example.com")
    print(f"Email validation: {'✅' if email_valid else '❌'}")
    
    # Log security event
    secure_log_event("user_login", "user123", {"status": "success", "ip_hash": "abc123"})
    
    print("✅ Security utilities demo completed")

if __name__ == "__main__":
    main()