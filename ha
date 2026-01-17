
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bazz Oill POS (V2026)</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        :root {
            --brand: #f59e0b;
            --brand-hover: #d97706;
            --dark: #0f172a;
            --bg: #020617;
            --card: #1e293b;
            --text: #f1f5f9;
            --danger: #ef4444;
            --success: #10b981;
            --warning: #f59e0b;
            --info: #3b82f6;
            --sidebar-w: 260px;
            --border: #334155;
            --input-bg: #334155;
        }

        * { box-sizing: border-box; font-family: 'Segoe UI', Tahoma, sans-serif; }
        body { margin: 0; background: var(--bg); color: var(--text); height: 100vh; display: flex; overflow: hidden; }

        /* --- PROFESSIONAL PRINT DESIGN (FIXED) --- */
        #printable-area { display: none; }
        
        @media print {
            /* 1. CONTINUOUS ROLL SETUP */
            @page { margin: 0; size: auto; } 
            
            /* 2. RESET DOCUMENT FLOW - CRITICAL FIX */
            html, body { 
                height: auto !important; 
                min-height: 0 !important;
                overflow: visible !important; 
                margin: 0 !important; 
                padding: 0 !important;
                display: block !important; /* Disable Flexbox */
                background: white !important;
                direction: ltr !important; /* Reset direction to prevent vertical inversion */
            }
            
            /* 3. HIDE APP UI COMPLETELY */
            .sidebar, .main-content, .modal-overlay, .top-bar, .save-indicator, #pos-menu, .no-print, #startup-screen, #login-screen { 
                display: none !important; 
            }
            
            /* 4. SHOW PRINT AREA CORRECTLY */
            #printable-area { 
                display: block !important; 
                position: static !important; /* No absolute positioning */
                width: 100% !important; 
                height: auto !important;
                background: white;
                color: black;
                margin: 0 !important;
                padding: 0 !important;
                visibility: visible !important;
            }
            
            #printable-area * {
                visibility: visible !important;
            }

            /* THERMAL RECEIPT STYLE */
            .print-thermal-container {
                direction: rtl !important; /* Restore RTL for text */
                margin: 0 auto; 
                text-align: center;
                font-family: 'Tahoma', 'Arial', sans-serif;
                font-size: 12px;
                font-weight: 600;
                padding-bottom: 5mm; /* Space for cutter */
                color: #000;
                display: block !important;
            }
            
            /* LOGO & HEADER */
            .thermal-logo {
                max-height: 50px;
                width: auto;
                max-width: 100%;
                margin: 5px auto;
                display: block;
                filter: grayscale(100%) contrast(150%);
            }

            .thermal-header h1 { 
                margin: 2px 0; 
                font-size: 1.2rem;
                font-weight: 800; 
                line-height: 1.2;
            }
            .thermal-header p { 
                margin: 0 0 5px 0; 
                font-size: 0.85rem; 
                color: #000;
            }
            
            .thermal-divider { 
                border-top: 1px dashed #000; 
                margin: 5px 0; 
                width: 100%;
                display: block;
            }

            .thermal-info {
                display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 2px;
            }

            /* TABLE FIXES */
            .thermal-table { width: 100%; border-collapse: collapse; text-align: right; margin-top: 5px; display: table !important; }
            .thermal-table th { border-bottom: 1px solid #000; font-size: 0.8rem; padding-bottom: 2px; text-align: right; }
            .thermal-table td { padding: 4px 0; vertical-align: top; font-size: 0.9rem; }
            
            .row-item { text-align: right; width: 55%; font-weight: bold; }
            .row-qty { text-align: center; width: 15%; }
            .row-price { text-align: left; width: 30%; }

            .thermal-totals-rtl { margin-top: 10px; text-align: right; direction: rtl; display: block; }
            
            .total-row { display: flex; justify-content: space-between; margin-bottom: 2px; font-size: 0.9rem; }
            .grand-total { 
                font-size: 1.4rem; 
                font-weight: 900; 
                border-top: 2px solid #000; 
                border-bottom: 2px solid #000; 
                padding: 5px 0; 
                margin-top: 5px; 
                display: block;
            }

            .thermal-footer { margin-top: 15px; text-align: center; font-size: 0.8rem; font-weight: bold; display: block; }
            
            /* KITCHEN SPECIFIC */
            .kitchen-row { display: flex; align-items: center; margin-bottom: 10px; border-bottom: 1px dashed #000; padding-bottom: 5px; }
            .kitchen-qty { font-size: 1.6rem; font-weight: 900; border: 3px solid #000; border-radius: 50%; width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; margin-left: 10px; flex-shrink: 0; }
            .kitchen-item { font-size: 1.4rem; font-weight: 800; text-align: right; flex: 1; }
            .kitchen-note { display: block; font-size: 1rem; font-weight: bold; margin-right: 60px; margin-bottom: 8px; font-style: italic; }
            .kitchen-box { border: 3px solid #000; padding: 15px; border-radius: 5px; margin-top: 10px; }

            /* A4 REPORT STYLES */
            .print-a4-container {
                width: 210mm;
                min-height: 297mm;
                margin: 0 auto;
                padding: 20mm;
                background: white;
                color: black;
                font-family: 'Segoe UI', sans-serif;
                box-shadow: none;
                direction: rtl;
            }
            .print-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid #000; padding-bottom: 20px; margin-bottom: 30px; }
            .print-summary-box { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; margin: 30px 0; }
            .p-box { background: #f8fafc; border-radius: 15px; padding: 20px; text-align: center; border: 2px solid #e2e8f0; }
            .p-box h3 { font-size: 1.2rem; margin-bottom: 10px; color: #4b5563; }
            .p-box h2 { font-size: 2rem; margin: 10px 0; }
            .print-table { width: 100%; border-collapse: collapse; margin-top: 20px; border-radius: 8px; overflow: hidden; }
            .print-table th { background: #1f2937; color: white; padding: 15px; text-align: right; font-weight: 600; }
            .print-table td { padding: 12px; border-bottom: 1px solid #e2e8f0; text-align: right; }
            .print-table tr:nth-child(even) { background: #f9fafb; }
            .section-title { font-size: 1.4rem; margin-top: 40px; padding-bottom: 10px; border-bottom: 2px solid #e2e8f0; color: #1f2937; font-weight: 700; }
            .report-footer { margin-top: 60px; text-align: center; padding-top: 20px; border-top: 2px solid #e2e8f0; color: #6b7280; font-size: 0.9rem; }
        }

        /* UI ELEMENTS */
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0, 0, 0, 0.95);
            z-index: 9999; display: flex; justify-content: center; align-items: center; color: white;
            backdrop-filter: blur(10px);
        }
        .glass-card {
            background: rgba(30, 41, 59, 0.95); backdrop-filter: blur(20px);
            padding: 40px; border-radius: 24px; border: 1px solid rgba(255,255,255,0.1);
            width: 500px; text-align: center; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.8);
        }
        
        /* Company Profile Modal & Tabs */
        .profile-modal {
            position: fixed; inset: 0; background: rgba(0,0,0,0.8); z-index: 2000;
            display: none; justify-content: center; align-items: center;
        }
        .profile-content {
            background: var(--card); width: 95%; max-width: 1200px; height: 90vh;
            border-radius: 20px; padding: 0; display: flex; flex-direction: column;
            overflow: hidden; color: var(--text); position: relative;
        }
        .profile-header {
            background: var(--brand); color: white; padding: 20px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .profile-tabs { display: flex; background: var(--dark); padding: 5px; gap: 5px; }
        .tab-btn {
            flex: 1; padding: 15px; border: none; background: transparent; cursor: pointer;
            font-weight: bold; font-size: 1rem; border-radius: 5px; transition: 0.2s;
            color: #94a3b8;
        }
        .tab-btn.active { background: var(--card); color: var(--brand); box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .tab-content { display: none; flex: 1; overflow-y: auto; padding: 20px; background: var(--bg); }
        .tab-content.active { display: block; }

        .pin-input {
            width: 100%; padding: 15px; text-align: center; font-size: 1.5rem; letter-spacing: 10px;
            border-radius: 12px; border: none; outline: none; margin-bottom: 20px;
            background: var(--input-bg); color: white; border: 1px solid var(--border);
        }

        /* SIDEBAR */
        .sidebar {
            width: var(--sidebar-w); background: var(--dark); color: #9ca3af; border-right: 1px solid var(--border);
            display: flex; flex-direction: column; transition: 0.3s; overflow: hidden; white-space: nowrap; 
        }
        .sidebar.closed { width: 0; }
        .sidebar-header { 
            padding: 30px; text-align: center; color: white; font-size: 1.5rem; 
            font-weight: bold; border-bottom: 1px solid #374151; letter-spacing: 1px;
        }
        .nav-item {
            padding: 15px 25px; cursor: pointer; display: flex; align-items: center; gap: 15px;
            transition: 0.2s; border-right: 4px solid transparent;
        }
        .nav-item:hover, .nav-item.active { background: #262626; color: white; border-right-color: white; }

        /* CONTENT */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        
        #connection-warning {
            background: #ff4757; color: white; text-align: center; padding: 5px; font-size: 0.9rem;
            display: none; animation: pulse 2s infinite; cursor: pointer;
        }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.8; } 100% { opacity: 1; } }

        .top-bar {
            height: 70px; background: var(--card); display: flex; align-items: center;
            justify-content: space-between; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); z-index: 10;
        }
        .workspace { flex: 1; padding: 20px; overflow-y: auto; display: none; background: var(--bg); }
        .workspace.active { display: block; animation: fadeIn 0.3s ease; }

        /* COMPONENTS */
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--card); padding: 25px; border-radius: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border-right: 5px solid var(--brand); }
        .stat-card h3 { margin: 0; font-size: 0.9rem; opacity: 0.7; }
        .stat-card h1 { margin: 10px 0 0; font-size: 1.8rem; }

        .btn {
            padding: 12px 20px; border: none; border-radius: 12px; cursor: pointer;
            font-weight: bold; transition: 0.3s; display: inline-flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-brand { background: var(--brand); color: white; }
        .btn-brand:hover { background: var(--brand-hover); }
        .btn-danger { background: var(--danger); color: white; }
        .btn-success { background: var(--success); color: white; }
        .btn-warning { background: var(--warning); color: white; }
        .btn-dark { background: var(--dark); color: white; }
        .btn-info { background: var(--info); color: white; }
        .btn-sm { padding: 5px 10px; font-size: 0.8rem; border-radius: 8px; }

        .card { background: var(--card); border-radius: 18px; padding: 20px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.3); margin-bottom: 20px; border: 1px solid var(--border); }
        .input-std, select.input-std { width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 10px; margin-bottom: 10px; outline: none; transition: 0.2s; background: var(--input-bg); color: white; }
        
        /* IMPROVED PRODUCT FORM */
        .form-grid-layout {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;
        }
        .form-section {
            background: rgba(255,255,255,0.03); border: 1px solid var(--border); border-radius: 15px; padding: 15px;
            position: relative;
        }
        .form-section-title {
            position: absolute; top: -12px; right: 15px; background: var(--card); padding: 0 10px;
            color: var(--brand); font-weight: bold; font-size: 0.9rem; border: 1px solid var(--border); border-radius: 20px;
        }
        
        .radio-group { display: flex; gap: 15px; flex-wrap: wrap; margin-bottom:10px; }
        .radio-label { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 0.9rem; font-weight: 500; }
        .radio-label input { width: 18px; height: 18px; accent-color: var(--brand); }

        /* ITEM SELECTION GRID */
        .item-select-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
            gap: 10px; max-height: 250px; overflow-y: auto;
            border: 2px solid var(--border); padding: 15px; border-radius: 12px; margin-bottom: 15px;
            background: var(--bg);
        }
        .item-select-card {
            background: var(--card); border: 2px solid transparent; border-radius: 10px;
            padding: 10px; text-align: center; cursor: pointer; transition: 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; justify-content: center; align-items: center;
        }
        .item-select-card:hover { transform: translateY(-3px); }
        .item-select-card.selected { border-color: var(--brand); background: #f3f4f6; position: relative; }

        /* POS UI */
        .pos-layout { display: flex; gap: 20px; height: calc(100vh - 110px); }
        .pos-menu { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .pos-bill { flex: 1; background: var(--card); border-radius: 20px; display: flex; flex-direction: column; box-shadow: -5px 0 15px rgba(0,0,0,0.3); overflow: hidden; border: 1px solid var(--border); }
        .pos-menu.collapsed { display: none; }
        .pos-bill.expanded { flex: 1; }
        
        /* UPDATED CATEGORY LIST VIEW */
        .pos-content-wrapper { display: flex; flex: 1; overflow: hidden; gap: 10px; }
        .category-list-container { width: 140px; overflow-y: auto; display: flex; flex-direction: column; gap: 8px; padding: 5px; border-left: 1px solid var(--border); }
        
        .cat-btn {
            padding: 15px 10px; border-radius: 10px; border: 1px solid var(--border); background: var(--card);
            cursor: pointer; font-weight: bold; color: var(--text); transition: 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05); text-align: center; width: 100%;
        }
        .cat-btn.active, .cat-btn:hover { background: var(--input-bg); color: var(--brand); border-color: var(--brand); }

        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 15px; overflow-y: auto; padding: 5px; flex: 1; }
        .p-card {
            background: var(--card); border-radius: 16px; padding: 25px 10px; text-align: center;
            cursor: pointer; transition: 0.2s; border: 2px solid transparent; 
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); height: 160px;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
        }
        .p-card:hover { border-color: var(--brand); transform: translateY(-3px); background: var(--input-bg); }
        .p-card b { font-size: 0.9rem; }
        .qty-badge { position: absolute; top: 10px; left: 10px; background: var(--dark); color: white; padding: 2px 8px; border-radius: 8px; font-size: 0.8rem; }

        .bill-header { padding: 20px; background: var(--card); border-bottom: 1px solid var(--border); text-align: center; }
        .bill-items { flex: 1; overflow-y: auto; padding: 15px; }
        
        .bill-row { 
            display: flex; justify-content: space-between; align-items: center; 
            padding: 8px 10px; margin-bottom: 8px; background: var(--input-bg); border-radius: 12px;
            border: 1px solid var(--border); box-shadow: 0 2px 4px rgba(0,0,0,0.02); color: var(--text);
            transition: 0.2s;
        }
        .bill-row:hover { transform: translateY(-2px); box-shadow: 0 5px 10px rgba(0,0,0,0.05); }
        
        .qty-control {
            display: flex; align-items: center; background: rgba(0,0,0,0.2);
            border-radius: 12px; padding: 4px; gap: 8px; margin: 0 10px;
        }
        .qty-btn {
            width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;
            border-radius: 10px; cursor: pointer; transition: 0.2s; color: white; font-size: 0.9rem;
        }
        .qty-btn.add { background: var(--brand); }
        .qty-btn.remove { background: #ef4444; }
        .qty-btn:hover { opacity: 0.9; transform: scale(1.05); }

        .bill-footer { padding: 20px; background: var(--card); border-top: 1px solid var(--border); }
        .delete-btn { width: 25px; height: 25px; border-radius: 50%; background: #fee2e2; color: var(--danger); display: flex; align-items: center; justify-content: center; cursor: pointer; }

        .report-table { width: 100%; border-collapse: collapse; background: var(--card); border-radius: 10px; overflow: hidden; color: var(--text); }
        .report-table th, .report-table td { padding: 15px; border-bottom: 1px solid var(--border); text-align: right; }
        .report-table th { background: var(--dark); color: var(--brand); font-weight: normal; }
        .report-table tr:hover { background: rgba(255,255,255,0.05); }

        /* COMPANIES */
        .company-card {
            background: var(--card); padding: 20px; border-radius: 15px; border-right: 5px solid var(--info);
            box-shadow: 0 4px 6px rgba(0,0,0,0.05); cursor: pointer; transition: 0.2s;
            display: flex; flex-direction: column; justify-content: space-between;
            border: 1px solid var(--border);
        }
        .company-card:hover { transform: translateY(-5px); box-shadow: 0 10px 15px rgba(0,0,0,0.1); }
        
        .general-market-card {
            background: linear-gradient(135deg, #a0522d 0%, #d2691e 100%);
            color: white !important;
            grid-column: span 2; 
            border-right: none;
            position: relative;
            overflow: hidden;
        }
        .general-market-card h3 { color: white !important; font-size: 1.5rem !important; }
        .general-market-card p { color: rgba(255,255,255,0.8) !important; }
        .general-market-card::after {
            content: "\f1b2"; font-family: "Font Awesome 6 Free"; font-weight: 900;
            position: absolute; left: -20px; bottom: -20px; font-size: 8rem; opacity: 0.1;
        }

        /* TABLE MAP STYLES */
        .table-card {
            background: var(--card); border-radius: 20px; padding: 20px; text-align: center;
            cursor: pointer; transition: 0.2s; border: 2px solid var(--border);
            display: flex; flex-direction: column; justify-content: center; align-items: center;
            height: 160px; position: relative; overflow: hidden;
        }
        .table-card:hover { transform: translateY(-3px); border-color: var(--brand); }
        .table-card.busy {
            background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%); color: white; border: none;
            box-shadow: 0 10px 20px rgba(220, 38, 38, 0.3);
            animation: pulse-red 2s infinite;
        }
        .table-card i { font-size: 3rem; margin-bottom: 15px; opacity: 0.8; transition: 0.3s; }
        .table-card h3 { margin: 0; font-size: 1.3rem; font-weight: bold; z-index: 1; }
        .table-card small { 
            background: rgba(255, 255, 255, 0.2) !important; 
            color: white !important; 
            padding: 2px 8px; border-radius: 10px; font-weight: bold; font-size: 0.9rem; 
        }
        @keyframes pulse-red { 
            0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(220, 38, 38, 0.7); } 
            70% { transform: scale(1.02); box-shadow: 0 0 0 15px rgba(220, 38, 38, 0); } 
            100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(220, 38, 38, 0); } 
        }

        .save-indicator {
            position: fixed; bottom: 20px; left: 20px; background: #000; color: #fff;
            padding: 10px 20px; border-radius: 30px; font-size: 0.9rem; z-index: 9999;
            display: none; animation: popIn 0.3s ease; box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        @keyframes popIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .click-animate { animation: bump 0.2s; }
        @keyframes bump { 0% { transform: scale(1); } 50% { transform: scale(0.9); } 100% { transform: scale(1); } }

        /* NEW SUPPLY MODAL */
        #new-supply-form {
            display: none; background: var(--card); padding: 25px; margin-bottom: 20px; 
            border-radius: 15px; border: 1px solid var(--border); box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1);
        }
        
        .status-badge-ok { background: #d1fae5; color: #065f46; padding: 2px 8px; border-radius: 5px; font-size: 0.8rem; }
        .status-badge-low { background: #fef3c7; color: #92400e; padding: 2px 8px; border-radius: 5px; font-size: 0.8rem; font-weight: bold; }
        .status-badge-out { background: #fee2e2; color: #b91c1c; padding: 2px 8px; border-radius: 5px; font-size: 0.8rem; font-weight: bold; }
        .status-badge-exp { background: #7f1d1d; color: white; padding: 2px 8px; border-radius: 5px; font-size: 0.8rem; }
        
        /* QUICK DISCOUNT BUTTONS */
        .discount-presets {
            display: flex; gap: 5px; margin-bottom: 5px;
        }
        .disc-btn {
            flex: 1; background: var(--input-bg); border: none; padding: 5px; border-radius: 5px; cursor: pointer; font-size: 0.8rem; font-weight: bold; color: white; transition: 0.2s;
        }
        .disc-btn:hover { background: var(--brand); }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Backup Section */
        .backup-section {
            background: linear-gradient(135deg, rgba(56, 189, 248, 0.1) 0%, rgba(14, 165, 233, 0.1) 100%);
            padding: 20px;
            border-radius: 15px;
            margin-top: 20px;
            border: 2px dashed #38bdf8;
        }
        
        /* POS ACTION LAYOUT */
        .pos-action-grid { display: flex; gap: 10px; margin-top: 10px; }
        .pos-action-left { display: flex; flex-direction: column; gap: 5px; flex: 1; }
        .pos-action-right { flex: 1; }
        .btn-sell-large { width: 100%; height: 100%; font-size: 1.5rem; background: var(--brand); color: white; border-radius: 12px; border: none; cursor: pointer; font-weight: bold; }
        .btn-sell-large:hover { background: var(--brand-hover); }

        /* FULLSCREEN CART (Expanded Mode) */
        .pos-bill.expanded .bill-items { flex: 0 0 80%; }
        .pos-bill.expanded .bill-header { flex: 0 0 5%; padding: 5px 15px; }
        .pos-bill.expanded .bill-footer { flex: 1; padding: 5px 15px; display: flex; flex-direction: column; justify-content: space-evenly; }
        
        .pos-bill.expanded .discount-wrapper { display: flex; align-items: center; gap: 5px; height: 20%; }
        .pos-bill.expanded .discount-presets { flex: 1; margin: 0; }
        .pos-bill.expanded #pos-discount { width: 80px; margin: 0; height: 100%; }
        
        .pos-bill.expanded .bill-total-section { margin: 0; padding: 5px; height: 20%; font-size: 0.9rem; }
        .pos-bill.expanded #pos-actions-default { height: 50%; }

        .carwash-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 15px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .carwash-card.washing {
            border-left: 5px solid var(--warning);
        }
        .carwash-card.done {
            border-left: 5px solid var(--success);
        }

    </style>
</head>
<body>

    <!-- PRINTABLE AREA (UPDATED KURDISH ARABIC SCRIPT & LOGO) -->
    <div id="printable-area"></div>

    <!-- COMPANY PROFILE MODAL (FIXED WITH PHONE ID) -->
    <div id="company-profile-modal" class="profile-modal">
        <div class="profile-content">
            <div class="profile-header">
                <div>
                    <h2 id="cp-name" style="margin:0;">کۆمپانیا</h2>
                    <small id="cp-phone" style="font-size:0.9rem; opacity:0.9;"></small>
                </div>
                <button style="background:none; border:none; color:white; font-size:1.5rem; cursor:pointer;" onclick="closeCompanyProfile()">✖</button>
            </div>
            <div class="profile-tabs">
                <button id="tab-btn-inventory" class="tab-btn active" onclick="switchTab('inventory')">📦 مەخزەن</button>
                <button id="tab-btn-history" class="tab-btn" onclick="switchTab('history')">📝 مێژوویا کڕینێ</button>
                <button id="tab-btn-ledger" class="tab-btn" onclick="switchTab('ledger')">📒 جەرد (قەرز & پارەدان)</button>
                <button id="tab-btn-supply" class="tab-btn" onclick="switchTab('supply')">➕ زێدەکرنا مەخزەنی</button>
            </div>
            <div id="tab-inventory" class="tab-content active">
                <h3>داتایێن مەخزەنی</h3>
                <div class="card">
                    <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:20px; margin-bottom:20px;">
                        <div class="p-box" style="background:var(--input-bg); border-color:var(--border)"><h4>کۆم بهایێ مەخزەنی</h4><h2 id="cp-total-stock-value">0</h2></div>
                        <div class="p-box" style="background:var(--input-bg); border-color:var(--border)"><h4>قەرزێ مای</h4><h2 id="cp-balance" style="color:var(--danger)">0</h2></div>
                        <div><button class="btn btn-success" onclick="payDebt()" style="height:100%; width:100%; font-size:1.2rem;"><i class="fas fa-money-bill-wave"></i> دانەڤا قەرزی</button></div>
                    </div>
                    <h4>لیستا هەمی ئایتمان</h4>
                    <div style="max-height:400px; overflow-y:auto;">
                        <table class="report-table">
                            <thead><tr><th>ئایتم</th><th>مەخزەن</th><th>Cost (تاک)</th><th>Price (تاک)</th><th>مفا</th><th>کریار</th></tr></thead>
                            <tbody id="cp-items-list"></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div id="tab-history" class="tab-content">
                <h3>مێژوویا کڕین و داواکاریان</h3>
                <div style="max-height:500px; overflow-y:auto;">
                    <table class="report-table">
                        <thead><tr><th>بەروار</th><th>ئایتم</th><th>ژمارا زێدەکرنێ</th><th>جۆر</th><th>کۆم بهای</th></tr></thead>
                        <tbody id="cp-history-list"></tbody>
                    </table>
                </div>
            </div>
            <div id="tab-ledger" class="tab-content">
                <h3>جەردێ پارەدان و قەرزان</h3>
                <button class="btn btn-warning" onclick="printLedger()"><i class="fas fa-print"></i> چاپکرن</button>
                <div style="max-height:500px; overflow-y:auto; margin-top:15px;">
                    <table class="report-table">
                        <thead><tr><th>بەروار</th><th>جۆرێ کارتی</th><th>بڕ</th><th>تێبینی</th></tr></thead>
                        <tbody id="cp-ledger-list"></tbody>
                    </table>
                </div>
            </div>
            <div id="tab-supply" class="tab-content">
                <h3>زێدەکرنا مەخزەنی</h3>
                <div class="card">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                        <h4 style="margin:0;">کۆمپانیا: <span id="supply-comp-name"></span></h4>
                        <button class="btn btn-brand" onclick="toggleSupplyForm()"><i class="fas fa-plus"></i> کڕینا نوی</button>
                    </div>
                    
                    <!-- NEW SUPPLY FORM -->
                    <div id="new-supply-form" class="supply-form-container">
                        <input type="hidden" id="supply-selected-prod-id">
                        
                        <!-- Header / Scan -->
                        <div class="supply-header">
                            <div style="flex:1">
                                <label style="font-weight:bold; display:block; margin-bottom:5px;">🔍 سکانکردنا بارکۆدی (Scan Barcode)</label>
                                <input type="text" id="supply-barcode" class="input-large-scan" placeholder="لێرە سکان بکە..." onkeyup="handleSupplyBarcode(this)">
                            </div>
                        </div>

                        <div class="supply-body">
                            <!-- Left: Item Grid -->
                            <div class="supply-grid-section">
                                <h4 style="margin-top:0; margin-bottom:10px; color:#6b7280;">هەڵبژارتنا ئایتمی (Select Item)</h4>
                                <div id="supply-item-grid" class="supply-items-grid"></div>
                            </div>

                            <!-- Right: Details Panel -->
                            <div class="supply-details-section">
                                <div id="supply-selected-info" class="selected-item-box">
                                    <i class="fas fa-box-open" style="font-size:2rem; opacity:0.5;"></i>
                                    <p>هیچ ئایتمەک نەهاتیە هەڵبژارتن</p>
                                </div>
                                
                                <div id="supply-cost-hint" style="display:none; margin-bottom:10px; font-size:0.9rem; color:var(--info);"></div>

                                <div class="supply-inputs-row">
                                    <div style="flex:1">
                                        <label>📦 کارتۆن</label>
                                        <input type="number" id="supply-qty-carton" class="input-big" placeholder="0" oninput="autoCalcSupply()">
                                    </div>
                                    <div style="flex:1">
                                        <label>🧩 دانە</label>
                                        <input type="number" id="supply-qty-unit" class="input-big" placeholder="0" oninput="autoCalcSupply()">
                                    </div>
                                </div>

                                <label style="margin-top:15px; display:block;">💰 کۆم بهای (Total Cost)</label>
                                <input type="number" id="supply-cost" class="input-big cost-input" placeholder="0" readonly>

                                <div style="margin-top:20px; background:var(--bg); padding:15px; border-radius:10px;">
                                    <label style="display:block; margin-bottom:10px; font-weight:bold;">جۆرێ پارەدانێ:</label>
                                    <div class="payment-type-toggle">
                                        <label class="pay-option">
                                            <input type="radio" name="supply-type" value="cash" checked>
                                            <span class="pay-box"><i class="fas fa-money-bill-wave"></i> نەقد (Cash)</span>
                                        </label>
                                        <label class="pay-option">
                                            <input type="radio" name="supply-type" value="credit">
                                            <span class="pay-box"><i class="fas fa-file-invoice"></i> قەرز (Credit)</span>
                                        </label>
                                    </div>
                                </div>

                                <div class="supply-actions">
                                    <button class="btn btn-success btn-xl" onclick="saveSupplyTransaction()"><i class="fas fa-check-circle"></i> تۆمارکرن</button>
                                    <button class="btn btn-dark btn-xl" onclick="toggleSupplyForm()">پاشگەزبوونەوە</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- SAVE INDICATOR -->
    <div id="save-indicator" class="save-indicator">
        <i class="fas fa-save"></i> هاتە پاراستن...
    </div>

    <!-- STARTUP SCREEN -->
    <div id="startup-screen" class="modal-overlay">
        <div class="glass-card">
            <i id="secret-icon" class="fas fa-oil-can" style="font-size: 4rem; color: white; margin-bottom: 20px; cursor:pointer; transition:0.2s;" onclick="triggerSecretCreate()"></i>
            <h1 style="margin-bottom: 5px; font-family: 'Segoe UI', sans-serif;">Bazz Oill</h1>
            <p style="opacity: 0.7; margin-bottom: 30px;">Service Center POS</p>
            <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 15px; margin-bottom: 20px; text-align:right;">
                <p style="font-size: 0.9rem; color: #fbbf24; margin-bottom: 10px;"><i class="fas fa-lock"></i> پاراستنا داتایان</p>
                <ol style="font-size: 0.85rem; padding-right: 20px; margin: 0; color: #e5e7eb;">
                    <li>هیڤیە فایلی <b>USB</b> هەڵبژێرە.</li>
                    <li>سیستەم **Direct Save** بکار دئینیت.</li>
                    <li>تەنێ ئێک پەیڤا نهێنی: <b>BAZZOILL2026</b></li>
                </ol>
            </div>
            <button class="btn btn-warning" style="width:100%; padding:20px; font-size:1.2rem; margin-bottom:15px; background:#fbbf24; color:black; font-family: sans-serif;" onclick="connectToFileSystem()">
                <i class="fas fa-folder-open"></i> ڤەکرنا فایلی (Database)
            </button>
        </div>
    </div>

    <!-- LOGIN SCREEN -->
    <div id="login-screen" class="modal-overlay" style="display:none;">
        <div class="glass-card" style="background: rgba(0, 0, 0, 0.9);">
            <h2><i class="fas fa-user-lock"></i> چوونە ژوور</h2>
            <p style="color:#aaa; font-size:0.8rem">پارێزراو ب SHA-256 | پەیڤا نهێنی: BAZZOILL2026</p>
            <input type="password" id="pin-code" class="pin-input" placeholder="PIN" maxlength="4" value="">
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                <button class="btn btn-brand" style="background:white; color:black" onclick="attemptLogin()">چوونە ژوور</button>
                <button class="btn btn-danger" onclick="location.reload()">زڤڕین</button>
            </div>
            <p id="login-error" style="color:var(--danger); margin-top:10px;"></p>
            <div style="margin-top:20px; padding-top:15px; border-top:1px solid rgba(255,255,255,0.1);">
                <p style="font-size:0.8rem; color:#aaa;">ڕۆڵ:</p>
                <p style="font-size:0.8rem; color:#fbbf24;">

                </p>
            </div>
        </div>
    </div>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-oil-can"></i> Bazz Oill</div>
        <nav style="flex:1">
            <div class="nav-item protected active" onclick="nav('dash')"><i class="fas fa-chart-line"></i> داشبۆرد</div>
            <div class="nav-item" onclick="nav('tables')"><i class="fas fa-cash-register"></i> مێز (Carts)</div>
            <div class="nav-item" id="nav-pos" onclick="nav('pos')" style="display:none"><i class="fas fa-cart-plus"></i> فرۆشتن (POS)</div>
            <div class="nav-item protected" onclick="nav('companies')"><i class="fas fa-building"></i> کۆمپانیا</div>
            <div class="nav-item protected" onclick="nav('warehouse')"><i class="fas fa-warehouse"></i> مەخزەن & ئاگەهدارکرن</div>
            <div class="nav-item protected" onclick="nav('products')"><i class="fas fa-tags"></i> پێناسەکرنا ئایتمی</div>
            <div class="nav-item protected" onclick="nav('expenses')"><i class="fas fa-wallet"></i> مەسرەف</div>
            <div class="nav-item protected" onclick="nav('reports')"><i class="fas fa-file-invoice-dollar"></i> ڕاپۆرت</div>
            <div class="nav-item" onclick="nav('carwash')"><i class="fas fa-car"></i> شوشتنا ترومبێلا</div>
        </nav>
        <div class="nav-item" onclick="nav('settings')" style="border-top:1px solid #374151"><i class="fas fa-cog"></i> ڕێکخستن</div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div id="connection-warning">🔴 پەیوەندیا فایلی پچڕیا! هیڤیە Refresh بکە و فایلی هەڵبژێرە.</div>

        <div class="top-bar">
            <div style="color: #64748b; font-size:0.9rem;">
                <button class="btn btn-dark btn-sm" onclick="toggleSidebar()" style="margin-left:10px;"><i class="fas fa-bars"></i></button>
                <i id="save-status-dot" class="fas fa-circle" style="color:gray; font-size:10px;"></i> 
                <span id="save-status-text">پەیوەندی نینە</span>
                <span style="margin-right:15px; background:#d1fae5; color:#065f46; padding:2px 8px; border-radius:10px; font-size:0.8rem;">نویکرنەڤە: کار دکەت</span>
            </div>
            <div style="display:flex; align-items:center; gap:15px;">
                <span id="user-display">کارمەند</span>
                <i class="fas fa-user-circle" style="font-size:1.5rem; cursor:pointer;" onclick="location.reload()"></i>
                <button class="btn btn-sm btn-danger" onclick="endShift()" title="End Shift"><i class="fas fa-power-off"></i></button>
            </div>
        </div>

        <!-- DASHBOARD -->
        <div id="view-dash" class="workspace active">
            <div class="stat-grid">
                <div class="stat-card">
                    <h3>فرۆشتنا ئەڤرۆ</h3>
                    <h1 id="st-sales">0</h1>
                    <small id="st-date-hint" style="font-size:0.7rem; color:#aaa;">(ڕۆژا کاری)</small>
                </div>
                <div class="stat-card" style="border-right-color:var(--danger)"><h3>مەسرەف</h3><h1 id="st-exp">0</h1></div>
                <div class="stat-card" style="border-right-color:var(--success)"><h3>قاسە (Net)</h3><h1 id="st-profit">0</h1></div>
                <div class="stat-card" style="border-right-color:var(--warning)"><h3>ژمارا وەسڵان</h3><h1 id="st-count">0</h1></div>
            </div>
            <div class="card">
                <h3><i class="fas fa-history"></i> مێزێن چالاک</h3>
                <div id="dash-tables" class="product-grid" style="margin-top:20px; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));"></div>
            </div>
        </div>

        <!-- TABLES -->
        <div id="view-tables" class="workspace">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                <h2>نەخشێ مێزان</h2>
                <div style="display:flex; gap:10px;">
                    <button class="btn btn-warning protected" onclick="transferTableUI()">🔄 ڤەگوهاستن</button>
                    <button class="btn btn-dark protected" onclick="printZReport()">📑 داخستنا ڕۆژێ (Z)</button>
                    <button class="btn btn-brand protected" onclick="addTable()">+ مێز</button>
                </div>
            </div>
            <div id="tables-grid" class="product-grid" style="grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));"></div>
        </div>

        <!-- COMPANIES VIEW -->
        <div id="view-companies" class="workspace">
            <h2><i class="fas fa-building"></i> ڕێڤەبەریا کۆمپانیا</h2>
            <div class="card">
                <div style="display:grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap:15px;">
                    <input type="text" id="c-name" class="input-std" placeholder="ناڤێ کۆمپانیێ">
                    <input type="text" id="c-phone" class="input-std" placeholder="ژمارا تەلەفۆنێ">
                    <input type="text" id="c-addr" class="input-std" placeholder="ناڤنیشان">
                    <button class="btn btn-info" onclick="saveCompany()">+ زێدەکرن</button>
                </div>
            </div>
            <div id="companies-grid" class="stat-grid" style="grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));"></div>
        </div>

        <!-- NEW WAREHOUSE VIEW -->
        <div id="view-warehouse" class="workspace">
            <h2><i class="fas fa-warehouse"></i> مەخزەن & ئاگەهدارکرن</h2>
            
            <div class="stat-grid">
                <div class="stat-card" style="border-right-color:var(--info)" onclick="renderWarehouse('all')">
                    <h3>هەمی ئایتم</h3>
                    <h1 id="wh-count-all">0</h1>
                </div>
                <div class="stat-card" style="border-right-color:var(--warning); cursor:pointer;" onclick="renderWarehouse('low')">
                    <h3>بەرەڤ خلاس بوونێ (Low Stock)</h3>
                    <h1 id="wh-count-low" style="color:var(--warning)">0</h1>
                </div>
                <div class="stat-card" style="border-right-color:var(--danger); cursor:pointer;" onclick="renderWarehouse('out')">
                    <h3>نەما (Out of Stock)</h3>
                    <h1 id="wh-count-out" style="color:var(--danger)">0</h1>
                </div>
                <div class="stat-card" style="border-right-color:#7f1d1d; cursor:pointer;" onclick="renderWarehouse('expired')">
                    <h3>بەسەرچوون (Expired)</h3>
                    <h1 id="wh-count-exp" style="color:#7f1d1d">0</h1>
                </div>
            </div>

            <div class="card">
                <h3 id="wh-list-title">📋 لیستا ئایتمان</h3>
                <div style="max-height:500px; overflow-y:auto;">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>ئایتم</th>
                                <th>دابینکەر (کۆمپانیا)</th>
                                <th>ژمارە (مەخزەن)</th>
                                <th>بەروارا بەسەرچوون</th>
                                <th>دۆخ (Status)</th>
                            </tr>
                        </thead>
                        <tbody id="wh-list-body"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- PRODUCTS DEFINITION VIEW -->
        <div id="view-products" class="workspace">
            <h2><i class="fas fa-box-open"></i> پێناسەکرنا ئایتمێ نوی</h2>
            
            <div class="card" id="product-form-card">
                <input type="hidden" id="p-id">
                
                <div class="form-grid-layout">
                    <!-- SECTION 1: BASIC INFO -->
                    <div class="form-section">
                        <div class="form-section-title">زانیاریێن سەرەتایی</div>
                        
                        <div class="radio-group">
                            <label class="radio-label"><input type="radio" name="p-source" value="direct" checked onchange="toggleSupplierInput()"> مەخزەن (Direct)</label>
                            <label class="radio-label"><input type="radio" name="p-source" value="market" onchange="toggleSupplierInput()"> دابینکەرێ گشتی (General Supplier)</label>
                            <label class="radio-label"><input type="radio" name="p-source" value="company" onchange="toggleSupplierInput()"> کۆمپانیا (Supplier)</label>
                        </div>

                        <label>ناڤێ ئایتمی</label>
                        <input type="text" id="p-name" class="input-std" placeholder="ناڤ (کوردی - English)">
                        
                        <label>بارکۆد (Barcode)</label>
                        <input type="text" id="p-barcode" class="input-std" placeholder="سکان یان نڤیسین">

                        <div id="supplier-select-wrapper" style="display:none;">
                            <label>کۆمپانیا / دابینکەر هەڵبژێرە</label>
                            <select id="p-supplier" class="input-std">
                                <option value="">هەڵبژێرە...</option>
                            </select>
                        </div>
                        
                        <label>پۆلێن (Category)</label>
                        <div style="display:flex; gap:10px;">
                            <select id="p-cat" class="input-std"></select>
                            <button class="btn btn-info" onclick="addCategory()" style="height: 46px;"><i class="fas fa-plus"></i></button>
                        </div>
                    </div>

                    <!-- SECTION 2: STOCK & COST -->
                    <div class="form-section">
                        <div class="form-section-title">تێچوو & مەخزەن</div>
                        
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                            <div>
                                <label style="font-size:0.8rem">دانە د کارتۆنی دا</label>
                                <input type="number" id="p-per-carton" class="input-std" placeholder="24" oninput="calcUnitCost()">
                            </div>
                            <div>
                                <label style="font-size:0.8rem">بهایێ کڕینا کارتۆنی (گشتی)</label>
                                <input type="number" id="p-total-buy-cost" class="input-std" placeholder="کۆیێ بهایێ کارتۆنی" oninput="calcUnitCost()">
                            </div>
                        </div>

                        <div style="background:rgba(59, 130, 246, 0.1); padding:8px; border-radius:8px; border:1px dashed var(--info); margin-bottom:10px;">
                            <label style="color:var(--info); font-weight:bold; font-size:0.9rem;">بهایێ کڕینا تاک (Cost)</label>
                            <input type="number" id="p-cost" class="input-std" placeholder="تێچووی تاک" style="margin:0;">
                        </div>
                        
                        <div style="display:flex; gap:10px;">
                            <div style="flex:1">
                                <label>مەخزەن (کارتۆن)</label><input type="number" id="p-cartons" class="input-std" placeholder="0">
                            </div>
                            <div style="flex:1">
                                <label>دانە (فەرد)</label><input type="number" id="p-loose" class="input-std" placeholder="0" value="0">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 3: PRICING & SAVE -->
                    <div class="form-section">
                        <div class="form-section-title">فرۆشتن</div>
                        
                        <label>بهایێ فرۆشتنێ (Price)</label>
                        <input type="number" id="p-price" class="input-std" placeholder="250" style="font-size:1.2rem; font-weight:bold;">
                        
                        <label>بەروارا ب سەرچوونێ</label>
                        <input type="date" id="p-expiry" class="input-std">
                        
                        <div style="display:flex; align-items:center; gap:10px; height:50px; margin-bottom:10px;">
                            <input type="checkbox" id="p-track" style="width:20px; height:20px;" checked>
                            <label>حیسابا مەخزەنی؟</label>
                        </div>
                        
                        <!-- NEW: NON-SELLABLE ITEMS CHECKBOX -->
                        <div style="display:flex; align-items:center; gap:10px; height:50px; margin-bottom:10px; background:rgba(16, 185, 129, 0.1); padding:0 10px; border-radius:10px; border:1px dashed var(--success);">
                            <input type="checkbox" id="p-for-sale" style="width:20px; height:20px;" checked>
                            <label style="color:#15803d; font-weight:bold;">پیشاندان ل POS (Sales Screen)</label>
                        </div>

                        <div style="display:flex; gap:10px;">
                            <button id="btn-save-prod" class="btn btn-brand" style="flex:1;" onclick="saveProduct()">
                                <i class="fas fa-save"></i> پاراستن
                            </button>
                            <button class="btn btn-info" style="flex:1;" onclick="saveProduct(true)">
                                <i class="fas fa-handshake"></i> ئایتمێ هەڤبەش
                            </button>
                            <button class="btn btn-dark" onclick="clearProductInputs()">
                                <i class="fas fa-eraser"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- LIST OF ALL PRODUCTS -->
            <div class="card" style="border-top: 5px solid var(--warning);">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3>📋 لیستا هەمی ئایتمان</h3>
                    <input type="text" class="input-std" style="width:250px; margin:0;" placeholder="🔍 لێگەریان..." onkeyup="renderProducts(this.value)">
                </div>
                <div id="product-list-container"></div>
            </div>
        </div>

        <!-- POS SYSTEM (UPDATED WITH DISCOUNT & LOGO) -->
        <div id="view-pos" class="workspace" style="padding:10px;">
            <div class="pos-layout">
                <div id="pos-menu-panel" class="pos-menu no-print">
                    <div style="display:flex; gap:15px; margin-bottom:15px;">
                        <input type="text" class="input-std" placeholder="🔍 لێگەریان..." style="margin:0; font-size:1.1rem;" onkeyup="renderPOSMenu(this.value)">
                    </div>
                    <div class="pos-content-wrapper">
                        <div id="pos-products" class="product-grid"></div>
                        <div id="category-tabs" class="category-list-container"></div>
                    </div>
                </div>
                
                <div id="pos-bill-panel" class="pos-bill">
                    <div class="bill-header">
                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                            <button class="btn btn-sm btn-dark no-print" onclick="togglePosMenu()"><i class="fas fa-expand-arrows-alt"></i></button>
                            <div style="text-align:right;">
                                <h2 id="bill-cafe-name" style="margin:0; font-size:1.2rem; color:var(--brand);">Bazz Oill</h2>
                                <p id="bill-cafe-info" style="margin:0; color:#6b7280; font-size:0.8rem;">07517959116</p>
                            </div>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; background:var(--bg); padding:10px; border-radius:10px; border:1px dashed var(--border);">
                            <span id="pos-active-table" style="font-weight:bold; font-size:1.1rem;">Meza 1</span>
                            <span id="pos-date" style="color:#6b7280; font-size:0.9rem;">1/7/2026</span>
                        </div>
                    </div>
                    <div class="bill-items" id="bill-rows"></div>
                    <div class="bill-footer">
                        
                        <div class="discount-wrapper">
                            <label style="font-size:0.9rem; font-weight:bold;">داشکاندن:</label>
                            <div class="discount-presets">
                                <button class="disc-btn" onclick="applyDiscountPercent(5)">%5</button>
                                <button class="disc-btn" onclick="applyDiscountPercent(10)">%10</button>
                                <button class="disc-btn" onclick="applyDiscountPercent(15)">%15</button>
                                <button class="disc-btn" onclick="applyDiscountPercent(20)">%20</button>
                                <button class="disc-btn" style="background:#fee2e2; color:red" onclick="applyDiscountPercent(0)">X</button>
                            </div>
                            <input type="number" id="pos-discount" class="input-std" placeholder="%" style="margin:0; text-align:center; width:70px;" oninput="renderBillTotal()">
                        </div>

                        <div class="bill-total-section" style="display:flex; justify-content:space-between; margin-bottom:15px; background:var(--input-bg); padding:15px; border-radius:12px;">
                            <span style="font-size:1.2rem; font-weight:bold;">کۆم (Total):</span>
                            <h2 id="bill-total" style="margin:0; color:var(--brand); font-size:1.8rem;">0</h2>
                        </div>
                        <p id="bill-footer-msg" style="text-align:center; font-size:0.8rem; margin-top:15px; display:none;">سوپاس بۆ سەرەدانا هەوە</p>
                        <div id="pos-actions-default" class="no-print">
                            <div class="pos-action-grid">
                                <div class="pos-action-left">
                                    <div style="display:flex; gap:5px;">
                                        <button class="btn btn-sm btn-warning" style="flex:1" onclick="printKitchen()"><i class="fas fa-utensils"></i> مەتبەخ</button>
                                        <button class="btn btn-sm btn-dark" style="flex:1" onclick="printProforma()"><i class="fas fa-print"></i> چاپ</button>
                                    </div>
                                    <div style="display:flex; gap:5px;">
                                        <button class="btn btn-sm btn-success" style="flex:1" onclick="nav('tables')"><i class="fas fa-pause"></i> ڕاگرتن</button>
                                        <button class="btn btn-sm btn-danger" style="flex:1" onclick="cancelOrder()"><i class="fas fa-trash"></i> پاککرن</button>
                                    </div>
                                </div>
                                <div class="pos-action-right">
                                    <button class="btn-sell-large" onclick="processPayment()"><i class="fas fa-check-circle"></i> فرۆشتن</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- EXPENSES (UPDATED WITH COMPANY SELECTOR) -->
        <div id="view-expenses" class="workspace">
            <h2><i class="fas fa-wallet"></i> مەسرەف</h2>
            <div class="card">
                <div style="display:grid; grid-template-columns: 1fr 2fr 1fr 1fr; gap:10px;">
                    <!-- Added Company Selector -->
                    <select id="e-comp-select" class="input-std">
                        <option value="">مەسرەفێن گشتی</option>
                    </select>
                    
                    <input type="text" id="e-note" class="input-std" placeholder="تێبینی">
                    <input type="number" id="e-amount" class="input-std" placeholder="بڕ">
                    <button class="btn btn-danger" style="height:46px" onclick="saveExpense()">تۆمارکرن</button>
                </div>
            </div>
            <div style="margin-bottom:10px;">
                <button class="btn btn-dark" onclick="printExpenses()"><i class="fas fa-print"></i> چاپکرنا لیستێ</button>
            </div>
            <div id="expense-list"></div>
        </div>

        <!-- REPORTS (ENHANCED) -->
        <div id="view-reports" class="workspace">
            <h2><i class="fas fa-file-invoice"></i> مێژوو & ڕاپۆرت</h2>
            
            <div class="card" style="border-right: 5px solid var(--info);">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <h3>📊 جەرد و ڕاپۆرتا ورد</h3>
                    <select id="report-scope" class="input-std" style="width:auto; margin:0; font-weight:bold;">
                        <option value="all">هەمی (Combined)</option>
                        <option value="cafe">کافتریا (Cafeteria)</option>
                        <option value="carwash">شوشتن (Car Wash)</option>
                    </select>
                    <div style="display:flex; gap:10px;">
                        <button class="btn btn-brand" onclick="printDetailedReport('daily')">📄 جەردا ئەڤرۆ (Daily)</button>
                        <button class="btn btn-dark" onclick="printDetailedReport('monthly')">📅 جەردا هەیڤانە (Monthly)</button>
                        <button class="btn btn-warning" onclick="printDebtReport()">📋 ڕاپۆرتا قەرزان</button>
                    </div>
                </div>
                <p style="color:#666; font-size:0.9rem; margin-top:5px;">ئەڤ ڕاپۆرتە داتایێن ئەرشیفکری ژی ب خۆڤە دگریت (Complete Data).</p>
            </div>

            <div class="card" style="border-right: 5px solid var(--success);">
                <h3>📅 ڕاپۆرتا هەیڤانە (پوختە)</h3>
                <div style="max-height: 250px; overflow-y:auto; margin-top:10px;">
                    <table class="report-table">
                        <thead><tr><th>هەیڤ</th><th>کۆما فرۆشتنێ</th><th>کۆما مەسرەفێ</th><th>مفا (Net)</th><th>کریار</th></tr></thead>
                        <tbody id="monthly-report-list"></tbody>
                    </table>
                </div>
            </div>
            
            <div class="stat-grid">
                 <div class="card" style="grid-column: span 3;">
                    <h3>📊 فرۆشتنا ڕۆژانە (Business Day)</h3>
                    <div style="max-height: 200px; overflow-y:auto; margin-top:10px;">
                        <table class="report-table"><thead><tr><th>مێژوو</th><th>ژمارا وەسڵان</th><th>کۆم بهای</th></tr></thead><tbody id="daily-sales-list"></tbody></table>
                    </div>
                 </div>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
                <div class="card">
                    <h3>📜 مێژوویا وەسڵان (تاک)</h3>
                    <input type="text" class="input-std" placeholder="لێگەریان (ژمارا وەسڵێ یان مێز)..." onkeyup="filterHistory(this.value)">
                    <div id="sales-history-list" style="max-height: 400px; overflow-y:auto;"></div>
                </div>
                <div class="card">
                    <h3>🛠️ تۆمار (Logs)</h3>
                    <div id="log-list" style="max-height: 400px; overflow-y:auto; background:var(--bg); padding:15px; border-radius:10px;"></div>
                </div>
            </div>
        </div>

        <!-- SETTINGS (ADDED LOGO UPLOAD & BACKUP FOR CASHIER) -->
        <div id="view-settings" class="workspace">
            <h2><i class="fas fa-cog"></i> ڕێکخستن</h2>
            <div class="card protected" style="border-top: 5px solid var(--brand);">
                <h3><i class="fas fa-print"></i> دیزاینا وەسڵێ (Receipt Design)</h3>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
                    <div><label>ناڤێ کافتریا</label><input type="text" id="set-cafe-name" class="input-std"></div>
                    <div><label>ژمارە / ناڤنیشان</label><input type="text" id="set-cafe-info" class="input-std"></div>
                    
                    <!-- FIX 3: Paper Size Selection -->
                    <div style="background:rgba(245, 158, 11, 0.1); padding:10px; border-radius:10px; border:1px solid var(--warning); grid-column: span 2;">
                        <label style="font-weight:bold; color:#854d0e;">قەبارێ وەرەقێ (Paper Size)</label>
                        <select id="set-paper-size" class="input-std">
                            <option value="80mm">80mm (Standard)</option>
                            <option value="60mm">60mm (Medium)</option>
                            <option value="57mm">57mm (Small/Card Machine)</option>
                        </select>
                    </div>

                    <!-- LOGO UPLOAD -->
                    <div style="grid-column: span 2; background:var(--bg); padding:10px; border-radius:10px; border:1px dashed var(--border);">
                        <label>لۆگۆیێ وەسڵێ (Logo)</label>
                        <input type="file" id="set-cafe-logo" class="input-std" accept="image/*">
                        <small style="color:#666">هیڤیە وێنەکێ بچیک هەڵبژێرە (JPG/PNG). پشتی هەڵبژارتنێ Save بکە.</small>
                    </div>

                    <div style="grid-column: span 2;"><label>نڤیسینا خوارێ</label><input type="text" id="set-cafe-footer" class="input-std"></div>
                    <div style="grid-column: span 2;"><button class="btn btn-brand" onclick="savePrintSettings()">💾 پاراستنا دیزاینێ</button></div>
                </div>
            </div>

            <!-- USER & SHIFT MANAGEMENT (NEW) -->
            <div class="card protected" style="border-top: 5px solid var(--info);">
                <h3><i class="fas fa-users"></i> ڕێڤەبرنا کارمەندان (Users & Shifts)</h3>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-bottom:20px;">
                    <div>
                        <h4>زێدەکرنا کارمەند</h4>
                        <input type="text" id="new-u-name" class="input-std" placeholder="ناڤ">
                        <input type="number" id="new-u-pin" class="input-std" placeholder="PIN (Code)">
                        <input type="number" id="new-u-rate" class="input-std" placeholder="مووچێ دەمژمێری (Hourly Rate)">
                        <select id="new-u-role" class="input-std">
                            <option value="cashier">Employee (Cashier)</option>
                            <option value="admin">Manager (Admin)</option>
                        </select>
                        <button class="btn btn-success" onclick="addUser()">+ زێدەکرن</button>
                    </div>
                    <div>
                        <h4>لیستا کارمەندان</h4>
                        <div id="users-list" style="max-height:150px; overflow-y:auto; background:var(--bg); padding:10px; border-radius:10px;"></div>
                    </div>
                </div>
                <hr>
                <h4><i class="fas fa-clock"></i> شیفتێن ئەڤرۆ (Active Shifts)</h4>
                <div id="shifts-list" style="max-height:200px; overflow-y:auto;">
                    <table class="report-table"><thead><tr><th>ناڤ</th><th>دەستپێک</th><th>دوماهیک</th><th>فرۆشتن (Work)</th><th>مووچە (Salary)</th></tr></thead><tbody id="shifts-body"></tbody></table>
                </div>
            </div>

            <!-- CAR WASH SETTINGS -->
            <div class="card protected" style="border-top: 5px solid #3b82f6;">
                <h3><i class="fas fa-car"></i> خزمەتگوزاریێن شوشتنێ</h3>
                <div style="display:grid; grid-template-columns: 2fr 1fr auto; gap:10px; margin-bottom: 20px;">
                    <input type="text" id="cw-service-name" class="input-std" placeholder="ناڤێ خزمەتگوزاریێ">
                    <input type="number" id="cw-service-price" class="input-std" placeholder="بها">
                    <button class="btn btn-info" onclick="addCarWashService()">+ زێدەکرن</button>
                </div>
                <h4>خزمەتگوزاریێن هەین</h4>
                <div id="cw-services-list" style="max-height:150px; overflow-y:auto; background:var(--bg); padding:10px; border-radius:10px;"></div>
            </div>
            
            <!-- BACKUP SECTION - AVAILABLE FOR BOTH ADMIN AND CASHIER -->
            <div class="card backup-section">
                <h3>💾 ڕێڤەبەریا داتابەیسێ</h3>
                <p>هەڵگرتنا داتایان و ناردنا ڕاپۆرتێ (Backup & Report)</p>
                <div style="display:flex; gap:10px; flex-wrap:wrap;">
                    <button class="btn btn-success" onclick="exportDB()"><i class="fas fa-download"></i> دەرخستنا JSON</button>
                    <button class="btn btn-info" onclick="backupToLocal()"><i class="fas fa-save"></i> هەڵگرتن ل سەر کۆمپیوتەری</button>
                    <button class="btn btn-warning protected" onclick="archiveOldData()"><i class="fas fa-archive"></i> ئەرشیفکرنا داتایێن کەڤن</button>
                </div>

                <hr style="margin: 20px 0; border-color: #bae6fd;">
                
                <h3><i class="fab fa-telegram"></i> ڕاپۆرت و باک ئەپ (Telegram)</h3>
                <div class="protected" style="width:100%; margin-bottom:10px;">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                        <div><label>Tokena Botê Rêveberi (Token)</label><input type="password" id="tg-bot-token" class="input-std" placeholder="Token..."></div>
                        <div><label>Chat ID (بۆ چەند کەسا , دابنێ)</label><input type="text" id="tg-chat-id" class="input-std" placeholder="Chat ID (e.g. 123, 456)..."></div>
                    </div>
                </div>
                <div style="display:flex; gap:10px; flex-wrap:wrap;">
                    <button class="btn btn-brand" onclick="sendTelegramReport()"><i class="fas fa-paper-plane"></i> ناردن بۆ ڕێڤەبەری (Auto)</button>
                    <button class="btn btn-dark" onclick="manualTelegramSend()"><i class="fas fa-user-edit"></i> ناردنا دەستی...</button>
                    <button class="btn btn-danger" onclick="downloadPDFReport()"><i class="fas fa-file-pdf"></i> تەنێ PDF چێکە</button>
                </div>
            </div>
        </div>

        <!-- CAR WASH VIEW -->
        <div id="view-carwash" class="workspace">
            <h2><i class="fas fa-car-side"></i> ڕێڤەبەریا شوشتنا ترومبێلان</h2>
            <div class="card">
                <div style="display:grid; grid-template-columns: 1.5fr 1fr 1fr 1fr auto; gap:15px; align-items:center; margin-bottom: 15px;">
                    <input type="text" id="cw-plate" class="input-std" placeholder="ژمارا تابلۆیێ" style="margin-bottom:0;">
                    <select id="cw-vehicle-type" class="input-std" style="margin-bottom:0;">
                        <option value="Private">تایبەت</option>
                        <option value="Taxi">تەکسی</option>
                    </select>
                    <select id="cw-service" class="input-std" style="margin-bottom:0;"></select>
                    <input type="number" id="cw-price" class="input-std" placeholder="بهایێ تایبەت" style="margin-bottom:0;">
                    <button class="btn btn-info" onclick="addCarToWashQueue()">+ زێدەکرن</button>
                </div>
                <div class="radio-group">
                    <label class="radio-label"><input type="radio" name="cw-payment" value="cash" checked> نەقد (Cash)</label>
                    <label class="radio-label"><input type="radio" name="cw-payment" value="account"> قەرز (Credit)</label>
                </div>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
                <div class="card">
                    <h3><i class="fas fa-hourglass-half"></i> د شوشتنێ دا</h3>
                    <div id="carwash-inprogress-list"></div>
                </div>
                <div class="card">
                    <h3><i class="fas fa-check-circle"></i> تەمام بوو</h3>
                    <div id="carwash-done-list"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- JAVASCRIPT LOGIC -->
    <script>
        // --- GLOBAL STATE ---
        let db = null;
        let activeTableId = null;
        let currentUser = null; 
        let activeCategory = 'all';
        let fileHandle = null; 
        let isFileConnected = false;
        let currentViewingCompanyId = null;
        let selectedSupplyProdId = null; 
        let lastTableState = ""; 
        let saveTimeout = null;

        const MASTER_PIN = '2026';
        // --- AUTH SYSTEM - UPDATED WITH SINGLE PASSWORD ---
        const MASTER_PASSWORD = 'BAZZOILL2026'; // Single password for both admin/cashier
        
        async function hashPIN(pin) {
            const encoder = new TextEncoder();
            const data = encoder.encode(pin);
            const hash = await crypto.subtle.digest('SHA-256', data);
            return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('');
        }

        // --- FORMATTING HELPER ---
        function formatCurrency(val) {
            return Math.round(val).toLocaleString();
        }

        // --- SECURITY ---
        function escapeHtml(unsafe) {
            if (typeof unsafe !== 'string') return unsafe;
            return unsafe.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }

        function getAllSales() {
            return [...(db.sales || []), ...(db.archive || [])];
        }

        // NEW: Filter sales based on Role
        function getReportSales() {
            const all = getAllSales();
            if(currentUser && currentUser.role === 'admin') return all;
            if(currentUser) return all.filter(s => s.cashier === currentUser.name);
            return [];
        }

        function getBusinessDate(dateObj = new Date()) {
            const d = new Date(dateObj);
            if(d.getHours() < 4) { d.setDate(d.getDate() - 1); }
            return d.toDateString(); 
        }
        function getBusinessMonth(dateObj = new Date()) {
            const d = new Date(dateObj);
            if(d.getHours() < 4) d.setDate(d.getDate() - 1);
            return `${d.getFullYear()}-${d.getMonth() + 1}`;
        }

        // --- STARTUP LOGIC ---
        let secretClicks = 0; let clickTimer;
        async function triggerSecretCreate() {
            if (!window.showSaveFilePicker) return alert("System requires Chrome/Edge on PC.");
            const icon = document.getElementById('secret-icon');
            icon.classList.remove('click-animate'); void icon.offsetWidth; icon.classList.add('click-animate');
            secretClicks++; clearTimeout(clickTimer);
            clickTimer = setTimeout(() => { secretClicks = 0; }, 2000);
            if(secretClicks === 5) {
                secretClicks = 0; const pass = prompt("🔐 پەیڤا نهێنی بۆ دروستکرنا فایلێ نوی:", MASTER_PASSWORD);
                if(pass === MASTER_PASSWORD) { await createNewDatabaseFile(); }
                else { alert("وشەی نهێنی هەڵەیە!"); }
            }
        }
        async function createNewDatabaseFile() {
            try {
                const options = { suggestedName: 'BazzOill_DB_2026.json', types: [{ description: 'JSON Database', accept: { 'application/json': ['.json'] } }] };
                const handle = await window.showSaveFilePicker(options);
                createDefaultDB();
                const writable = await handle.createWritable();
                await writable.write(JSON.stringify(db));
                await writable.close();
                fileHandle = handle; isFileConnected = true;
                alert("✅ فایلێ نوی دروست بوو! نوکە سیستەم یێ ئامادەیە.");
                document.getElementById('startup-screen').style.display = 'none';
                document.getElementById('login-screen').style.display = 'flex';
                updateSaveStatus(true);
            } catch (err) { if(err.name !== 'AbortError') alert("Error: " + err.message); }
        }
        async function connectToFileSystem() {
            if (!window.showOpenFilePicker) return alert("System requires Chrome/Edge on PC.");
            
            // No password check here - just open file
            try {
                const [handle] = await window.showOpenFilePicker({ types: [{ description: 'JSON Database', accept: { 'application/json': ['.json'] } }], multiple: false });
                fileHandle = handle;
                const file = await fileHandle.getFile();
                const text = await file.text();
                if(text.trim() === "") { alert("فایل یێ بەتاڵە!"); return; } 
                else { try { db = JSON.parse(text); } catch(e) { alert("فایلێ دیارکری یێ تێکچووی."); return; } }
                
                if(!db.companies) db.companies = [];
                if(!db.supplies) db.supplies = [];
                if(!db.archive) db.archive = []; 
                if(!db.ledger) db.ledger = []; 
                if(!db.expenses) db.expenses = [];
                if(!db.sales) db.sales = [];
                if(!db.logs) db.logs = [];
                if(!db.carwash) db.carwash = { queue: [], services: [] };
                if(!db.users) db.users = []; // Ensure users exist
                if(!db.shifts) db.shifts = []; // Ensure shifts exist
                if(!db.categories) {
                    const existing = new Set(db.products.map(p => p.cat).filter(Boolean));
                    if(existing.size === 0) existing.add("General");
                    db.categories = [...existing];
                }

                isFileConnected = true; updateSaveStatus(true);
                document.getElementById('startup-screen').style.display = 'none';
                document.getElementById('login-screen').style.display = 'flex';
                document.getElementById('connection-warning').style.display = 'none';
                startAutoRefresh();

            } catch (err) { if(err.name !== 'AbortError') alert("هەڵە لە کردنەوەی فایل: " + err.message); }
        }

        function startAutoRefresh() {
            setInterval(() => {
                if(db && isFileConnected) {
                    updateStats(); renderDashboard();
                    updateNavAlerts(); // Check for alerts
                    if(document.getElementById('view-tables').classList.contains('active')) { renderTables(); }
                }
            }, 3000); 
        }

        // --- DATA SAFETY ---
        window.onbeforeunload = function() {
            if (saveTimeout !== null) {
                return "هێشتا داتا نەهاتینە پاراستن! دڵنیای تە دڤێت دەربکەڤی؟";
            }
        };

        function scheduleSave() {
            const indicator = document.getElementById('save-indicator');
            indicator.style.display = 'block';
            indicator.innerHTML = '<i class="fas fa-clock"></i> چاڤەڕێ بە...';
            indicator.style.background = '#f59e0b'; 
            clearTimeout(saveTimeout);
            saveTimeout = setTimeout(() => { saveToDisk(); }, 2000); 
        }

        async function saveToDisk() {
            if (fileHandle && isFileConnected) {
                try {
                    const writable = await fileHandle.createWritable();
                    await writable.write(JSON.stringify(db));
                    await writable.close();
                    const indicator = document.getElementById('save-indicator');
                    indicator.innerHTML = '<i class="fas fa-save"></i> هاتە پاراستن';
                    indicator.style.background = 'black';
                    setTimeout(() => { indicator.style.display = 'none'; }, 2000);
                    saveTimeout = null; 
                } catch (err) {
                    updateSaveStatus(false); isFileConnected = false;
                    document.getElementById('connection-warning').style.display = 'block';
                    alert("🔴 ئاگەهداربە: پەیوەندی ب فایلی ڤە پچڕیا!");
                }
            }
        }
        
        function updateSaveStatus(connected) {
            const dot = document.getElementById('save-status-dot'); const txt = document.getElementById('save-status-text');
            if(connected) { dot.style.color = 'var(--success)'; txt.innerText = "پەیوەندی هەیە (USB)"; } 
            else { dot.style.color = 'red'; txt.innerText = "پەیوەندی نینە"; }
        }

        function createDefaultDB() {
            db = { 
                tables: [], products: [], companies: [], supplies: [], 
                sales: [], expenses: [], logs: [], archive: [], ledger: [],
                users: [
                    { id: 1, name: 'Manager', pin: '2026', role: 'admin' },
                    { id: 2, name: 'Cashier', pin: '1234', role: 'cashier', hourlyRate: 5000 }
                ],
                shifts: [],
                carwash: { 
                    queue: [], 
                    services: [ {id: 1, name: 'Standard Wash', price: 10000}, {id: 2, name: 'Premium Wash + Wax', price: 15000}, {id: 3, name: 'Interior Cleaning', price: 12000} ] 
                },
                // UPDATE: Added paperWidth default
                settings: { cafeName: "Bazz Oill", cafeInfo: "07517959116", footer: "ڕۆژەکا خۆش!", logo: "", paperWidth: "80mm", tgToken: "", tgChatId: "" },
                categories: ["General", "Drinks", "Food", "Snacks", "Car Wash Services"]
            };
            db.products.push({id: 1, name: 'Water', barcode: '123456', supplier:'Direct Store', price: 250, cost:150, itemsPerCarton:1, cat: 'Drinks', trackStock: false, qty: 0, expiry:''});
            db.companies.push({ id: 999999, name: "General Supplies", phone: "-", address: "بازاڕێ گشتی", balance: 0 });
            db.tables.push({id: 1, name: 'T1', items:[]}, {id:2, name:'T2', items:[]});
        }

        async function attemptLogin() {
            if(!db.users || db.users.length === 0) {
                // Fallback if no users in DB
                db.users = [{ id: 1, name: 'Manager', pin: '', role: 'admin' }];
            }

            const pin = document.getElementById('pin-code').value;
            // Simple PIN check against DB
            const user = db.users.find(u => u.pin === pin);
            
            if (user) {
                currentUser = user;
                document.getElementById('login-screen').style.display = 'none';
                document.getElementById('user-display').innerText = user.name + " (" + user.role + ")";
                
                const protectedItems = document.querySelectorAll('.protected');
                // Initially show/hide based on actual role
                protectedItems.forEach(el => { 
                    el.style.display = (user.role === 'admin') ? '' : 'none'; 
                });
                
                // START SHIFT LOGIC
                if(!db.shifts) db.shifts = [];
                const openShift = db.shifts.find(s => s.userId === user.id && !s.endTime);
                if(!openShift) {
                    db.shifts.push({
                        id: Date.now(), userId: user.id, userName: user.name, 
                        startTime: new Date(), endTime: null, hourlyRate: user.hourlyRate || 0
                    });
                    scheduleSave();
                }

                renderAll(); applyPrintSettings();
                checkExpiryPopup();

                if(user.role === 'admin') {
                    nav('dash');
                } else {
                    nav('tables');
                }
            } else { 
                document.getElementById('login-error').innerText = "پین کۆد یێ خەلەتە!"; 
            }
        }

        function endShift() {
            if(!currentUser) return;
            if(!confirm("دڵنیای تە دڤێت شیفتی ب دوماهیک بینی؟ (End Shift)")) return;
            
            const shift = db.shifts.find(s => s.userId === currentUser.id && !s.endTime);
            if(shift) {
                shift.endTime = new Date();
                scheduleSave();
                alert("شیفت ب سەرکەفتیانە هاتە گرتن.");
                location.reload(); // Logout
            } else {
                alert("چ شیفتێن ڤەکری نینن.");
                location.reload();
            }
        }

        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('closed');
        }

        function nav(id) {
            document.querySelectorAll('.workspace').forEach(w => w.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            document.getElementById('view-' + id).classList.add('active');
            const navBtn = document.querySelector(`.nav-item[onclick="nav('${id}')"]`);
            if(navBtn) navBtn.classList.add('active');
            
            if(id === 'companies') renderCompanies(); 
            if(id === 'products') { renderCategorySelect(); renderProducts(); }
            if(id === 'warehouse') renderWarehouse('all');
            if(id === 'reports') { renderSalesHistory(); renderDailySales(); renderMonthlyReport(); renderLogs(); }
            if(id === 'tables') { lastTableState = ""; renderTables(); }
            if(id === 'expenses') { renderExpenses(); }
            if(id === 'settings') { renderUsers(); renderShifts(); renderCarWashServicesSettings(); }
            if(id === 'carwash') renderCarWash();
        }
        function renderAll() { if(!db) return; renderDashboard(); renderTables(); renderExpenses(); updateStats(); }

        // --- COMPANY SYSTEM ---
        function saveCompany() {
            const name = document.getElementById('c-name').value;
            const phone = document.getElementById('c-phone').value;
            const addr = document.getElementById('c-addr').value;
            if(!name) return alert("هیڤیە ناڤێ کۆمپانیێ بنڤیسە!");
            db.companies.push({ id: Date.now(), name, phone, address: addr, balance: 0 });
            document.getElementById('c-name').value = ''; document.getElementById('c-phone').value = ''; document.getElementById('c-addr').value = '';
            scheduleSave(); renderCompanies();
        }

        function renderCompanies() {
            const grid = document.getElementById('companies-grid'); grid.innerHTML = '';
            const sortedCompanies = db.companies.sort((a, b) => {;
                if (a.name === "General Supplies") return -1; if (b.name === "General Supplies") return 1; return 0;
            });
            sortedCompanies.forEach(c => {
                const isGeneral = c.name === "General Supplies";
                grid.innerHTML += `
                <div class="company-card ${isGeneral ? 'general-market-card' : ''}" onclick="openCompanyProfile(${c.id})">
                    <h3 style="margin:0; color:var(--brand)">${isGeneral ? '<i class="fas fa-globe"></i> ' : ''}${escapeHtml(c.name)}</h3>
                    <p style="color:${isGeneral ? 'white' : '#666'}; font-size:0.9rem; margin:10px 0;"><i class="fas fa-phone"></i> ${escapeHtml(c.phone)}</p>
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-weight:bold; color:${c.balance > 0 ? '#dc2626' : '#10b981'}">قەرز: ${c.balance ? c.balance.toLocaleString() : 0}</span>
                        ${!isGeneral ? `<button class="btn btn-danger btn-sm" style="padding:5px 10px; font-size:0.8rem;" onclick="event.stopPropagation(); deleteCompany(${c.id})"><i class="fas fa-trash"></i></button>` : ''}
                    </div>
                </div>`;
            });
        }

        function deleteCompany(id) {
            if(confirm("دڵنیای ژ ژێبرنێ؟ ئایتمێن وێ دێ چنە سەر General Supplies.")) { 
                const comp = db.companies.find(c => c.id === id);
                if(comp) {
                    db.products.forEach(p => {
                        if(p.supplier === comp.name) p.supplier = "General Supplies";
                    });
                    db.companies = db.companies.filter(c => c.id !== id); 
                    scheduleSave(); renderCompanies(); 
                }
            }
        }

        // --- PROFILE & SUPPLY & DEBT ---
        function openCompanyProfile(id) {
            const comp = db.companies.find(c => c.id === id); if(!comp) return;
            currentViewingCompanyId = id;
            
            // FIXED: These IDs now exist in the HTML
            document.getElementById('cp-name').innerText = comp.name;
            document.getElementById('cp-phone').innerText = comp.phone;
            
            document.getElementById('cp-balance').innerText = formatCurrency(comp.balance || 0) + " IQD";
            switchTab('inventory'); 
            renderCompanyInventory(comp.name); 
            renderCompanyHistory(comp.name);
            renderLedgerHistory(id); 
            document.getElementById('company-profile-modal').style.display = 'flex';
        }

        function switchTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById('tab-' + tabName).classList.add('active');
            document.getElementById('tab-btn-' + tabName).classList.add('active');
        }

        function renderCompanyInventory(compName) {
            const products = db.products.filter(p => p.supplier === compName);
            const totalValue = products.reduce((sum, p) => sum + (p.cost * (p.trackStock ? p.qty : 0)), 0);
            document.getElementById('cp-total-stock-value').innerText = formatCurrency(totalValue);
            const list = document.getElementById('cp-items-list'); list.innerHTML = '';
            products.forEach(p => {
                let stockTxt = p.trackStock ? (p.itemsPerCarton > 1 ? `${Math.floor(p.qty/p.itemsPerCarton)} ک، ${p.qty%p.itemsPerCarton} د` : `${p.qty} د`) : '∞';
                let unitProfit = p.price - p.cost;
                list.innerHTML += `<tr><td><b>${escapeHtml(p.name)}</b></td><td style="color:${p.trackStock && p.qty<5 ? 'red' : 'black'}">${stockTxt}</td><td>${formatCurrency(p.cost)}</td><td>${formatCurrency(p.price)}</td><td style="color:${unitProfit > 0 ? 'green':'red'}">${formatCurrency(unitProfit)}</td><td><button class="btn btn-brand btn-sm" onclick="editProdFromProfile(${p.id})"><i class="fas fa-edit"></i></button><button class="btn btn-danger btn-sm" onclick="deleteProdFromProfile(${p.id}, '${escapeHtml(compName)}')"><i class="fas fa-trash"></i></button></td></tr>`;
            });
        }

        function editProdFromProfile(id) { closeCompanyProfile(); nav('products'); editProd(id); }
        function deleteProdFromProfile(id, compName) {
            const isActive = db.tables.some(t => t.items.some(i => i.id === id));
            if (isActive) return alert("⛔ نەشێی ڤی ئایتمی ژێ ببەی! نوکە ل سەر مێزەکێ یێ هاتیە داواکرن.");
            if(confirm("دڵنیای ژ ژێبرنێ؟")) { db.products = db.products.filter(p => p.id !== id); scheduleSave(); renderCompanyInventory(compName); }
        }

        function renderCompanyHistory(compName) {
            const list = document.getElementById('cp-history-list'); list.innerHTML = '';
            const history = db.supplies.filter(s => s.company === compName).reverse();
            if(history.length === 0) { list.innerHTML = '<tr><td colspan="5" style="text-align:center; color:#999;">چ تۆمار نینن</td></tr>'; return; }
            history.forEach(h => {
                let typeBadge = h.type === 'credit' ? '<span style="background:#fee2e2; color:#b91c1c; padding:2px 8px; border-radius:5px;">قەرز</span>' : '<span style="background:#d1fae5; color:#065f46; padding:2px 8px; border-radius:5px;">نەقد</span>';
                list.innerHTML += `<tr><td>${new Date(h.date).toLocaleDateString()}</td><td>${escapeHtml(h.itemName)}</td><td style="color:var(--success)">+${h.qtyAdded}</td><td>${typeBadge}</td><td>${formatCurrency(h.totalCost)}</td></tr>`;
            });
        }

        function renderLedgerHistory(compId) {
            const list = document.getElementById('cp-ledger-list'); list.innerHTML = '';
            if(!db.ledger) db.ledger = [];
            
            const entries = db.ledger.filter(l => l.companyId === compId).reverse();
            
            if(entries.length === 0) { list.innerHTML = '<tr><td colspan="4" style="text-align:center;color:#999">چ لڤین نینن</td></tr>'; return; }
            
            entries.forEach(l => {
                const isDebt = l.type === 'credit_purchase';
                const typeHtml = isDebt 
                    ? '<span style="color:red; font-weight:bold"><i class="fas fa-arrow-down"></i> وەرگرتن (قەرز)</span>' 
                    : '<span style="color:green; font-weight:bold"><i class="fas fa-arrow-up"></i> دانەڤا قەرزی</span>';
                
                list.innerHTML += `<tr>
                    <td>${new Date(l.date).toLocaleDateString()}</td>
                    <td>${typeHtml}</td>
                    <td>${formatCurrency(l.amount)}</td>
                    <td>${escapeHtml(l.note)}</td>
                </tr>`;
            });
        }

        function toggleSupplyForm() {
            const form = document.getElementById('new-supply-form');
            const isHidden = form.style.display === 'none' || form.style.display === '';
            form.style.display = isHidden ? 'block' : 'none';
            if(isHidden) {
                const comp = db.companies.find(c => c.id === currentViewingCompanyId);
                document.getElementById('supply-comp-name').innerText = comp.name;
                const grid = document.getElementById('supply-item-grid'); grid.innerHTML = '';
                const prods = db.products.filter(p => p.supplier === comp.name);
                
                // Reset Info Box
                document.getElementById('supply-selected-info').innerHTML = '<i class="fas fa-box-open" style="font-size:2rem; opacity:0.5;"></i><p>هیچ ئایتمەک نەهاتیە هەڵبژارتن</p>';
                document.getElementById('supply-selected-info').classList.remove('active');

                if(prods.length === 0) { grid.innerHTML = '<p style="color:#999; padding:20px;">چ ئایتم نەهاتینە پێناسەکرن بۆ ڤێ کۆمپانیێ.</p>'; return; }
                prods.forEach(p => {
                    grid.innerHTML += `<div class="supply-item-card" id="sel-card-${p.id}" onclick="selectSupplyItem(${p.id})"><i class="fas fa-box" style="font-size:1.5rem; margin-bottom:5px;"></i><b>${escapeHtml(p.name)}</b><small>${formatCurrency(p.cost)}</small></div>`;
                });
                selectedSupplyProdId = null; document.getElementById('supply-selected-prod-id').value = "";
                document.getElementById('supply-cost-hint').style.display = "none";
                const barInput = document.getElementById('supply-barcode'); if(barInput) { barInput.value = ''; setTimeout(() => barInput.focus(), 100); }
            }
        }

        function selectSupplyItem(id) {
            document.querySelectorAll('.supply-item-card').forEach(el => el.classList.remove('selected'));
            const card = document.getElementById('sel-card-'+id);
            if(card) card.classList.add('selected');
            
            selectedSupplyProdId = id; 
            document.getElementById('supply-selected-prod-id').value = id;
            
            // Update Info Box
            const p = db.products.find(x => x.id === id);
            const infoBox = document.getElementById('supply-selected-info');
            if(p) {
                infoBox.innerHTML = `<h3 style="margin:0; color:var(--brand)">${escapeHtml(p.name)}</h3><p style="margin:5px 0; color:#666">Cost: ${formatCurrency(p.cost)}</p>`;
                infoBox.classList.add('active');
            }
            
            autoCalcSupply();
        }

        function handleSupplyBarcode(input) {
            const val = input.value.trim();
            if(!val) return;
            const comp = db.companies.find(c => c.id === currentViewingCompanyId);
            if(!comp) return;
            
            const p = db.products.find(x => x.barcode === val && x.supplier === comp.name);
            if(p) {
                selectSupplyItem(p.id);
                input.value = ''; 
            }
        }

        function autoCalcSupply() {
            if(!selectedSupplyProdId) return;
            const p = db.products.find(x => x.id == selectedSupplyProdId);
            const cartons = parseInt(document.getElementById('supply-qty-carton').value) || 0;
            const units = parseInt(document.getElementById('supply-qty-unit').value) || 0;
            
            const costPerUnit = p.cost; 
            const costPerCarton = p.cost * p.itemsPerCarton;
            
            const totalCost = (cartons * costPerCarton) + (units * costPerUnit);
            document.getElementById('supply-cost').value = totalCost;
            
            const hint = document.getElementById('supply-cost-hint');
            hint.style.display = 'block';
            hint.innerHTML = `<i class="fas fa-info-circle"></i> نرخی تاک: <b>${formatCurrency(costPerUnit)}</b> | نرخی کارتۆن: <b>${formatCurrency(costPerCarton)}</b>`;
        }

        function saveSupplyTransaction() {
            const comp = db.companies.find(c => c.id === currentViewingCompanyId);
            const prodId = selectedSupplyProdId;
            const cartonsInput = parseInt(document.getElementById('supply-qty-carton').value) || 0;
            const unitsInput = parseInt(document.getElementById('supply-qty-unit').value) || 0;
            const cost = parseFloat(document.getElementById('supply-cost').value) || 0;
            const type = document.querySelector('input[name="supply-type"]:checked').value; 

            if(!prodId) return alert("هیڤیە ئایتمی هەڵبژێرە!");
            if(cartonsInput === 0 && unitsInput === 0) return alert("هیڤیە ژمارێ بنڤیسە!");

            const product = db.products.find(p => p.id == prodId);
            const totalItemsToAdd = (cartonsInput * product.itemsPerCarton) + unitsInput;

            if(product.trackStock) { product.qty += totalItemsToAdd; }

            // ISSUE 1 FIXED: Ensure Expense is recorded clearly for Cash payments
            let expenseMsg = "";
            if(type === 'credit') {
                if(!comp.balance) comp.balance = 0;
                comp.balance += cost; 
                
                if(!db.ledger) db.ledger = [];
                db.ledger.push({
                    id: Date.now(),
                    companyId: comp.id,
                    type: 'credit_purchase',
                    amount: cost,
                    date: new Date(),
                    note: `کڕین: ${product.name} (قەرز)`
                });

            } else {
                // Ensure db.expenses exists
                if(!db.expenses) db.expenses = [];
                
                db.expenses.push({ 
                    id: Date.now(), 
                    note: `کڕین: ${product.name} ژ ${comp.name}`, 
                    amount: cost, 
                    date: new Date(), 
                    user: currentUser ? currentUser.name : 'System' 
                });
                expenseMsg = `\n💰 ${formatCurrency(cost)} چووە سەر مەسرەفێ.`;
            }

            db.supplies.push({ 
                id: Date.now(), company: comp.name, prodId: product.id, 
                itemName: product.name, qtyAdded: totalItemsToAdd, totalCost: cost, 
                date: new Date(), type: type 
            });

            scheduleSave();
            
            document.getElementById('supply-qty-carton').value = ''; 
            document.getElementById('supply-qty-unit').value = ''; 
            document.getElementById('supply-cost').value = '';
            toggleSupplyForm(); 
            
            renderCompanyInventory(comp.name); 
            renderCompanyHistory(comp.name);
            renderLedgerHistory(comp.id);
            document.getElementById('cp-balance').innerText = formatCurrency(comp.balance || 0) + " IQD";
            renderExpenses();
            updateStats(); // Force dashboard update
            
            alert(`✅ ${product.name} هاتە کڕین.${expenseMsg}`);
        }
        
        function payDebt() {
            const comp = db.companies.find(c => c.id === currentViewingCompanyId);
            if(!comp.balance || Math.round(comp.balance) <= 0) return alert("چ قەرز ل سەر ڤێ کۆمپانیێ نینن.");
            
            const amount = prompt(`بڕێ قەرزی: ${formatCurrency(comp.balance)}\nچەند پارە دێ دەيەڤە؟`);
            if(!amount) return;
            const val = parseFloat(amount);
            if(val <= 0) return;

            if(val > Math.round(comp.balance) + 1) { // +1 for small float tolerance
                alert(`⚠️ نەشێی بڕێ ${formatCurrency(val)} بدەیەڤە! قەرز تەنێ ${formatCurrency(comp.balance)} دینارە.`);
                return;
            }

            comp.balance -= val;
            
            if(!db.ledger) db.ledger = [];
            db.ledger.push({
                id: Date.now(),
                companyId: comp.id,
                type: 'payment',
                amount: val,
                date: new Date(),
                note: 'دانەڤا قەرزی'
            });

            db.expenses.push({ id: Date.now(), note: `دانەڤا قەرزی: ${comp.name}`, amount: val, date: new Date(), user: currentUser ? currentUser.name : 'System' });
            
            scheduleSave();
            document.getElementById('cp-balance').innerText = formatCurrency(comp.balance) + " IQD";
            renderLedgerHistory(comp.id);
            renderExpenses();
            alert("✅ قەرز هاتە دان و چووە سەر مەسرەفێ.");
        }

        function closeCompanyProfile() { document.getElementById('company-profile-modal').style.display = 'none'; renderCompanies(); }

        // --- WAREHOUSE ---
        function renderWarehouse(filter) {
            const allItems = db.products.filter(p => p.trackStock);
            const lowItems = allItems.filter(p => p.qty > 0 && p.qty <= 5);
            const outItems = allItems.filter(p => p.qty <= 0);
            const today = new Date();
            const expItems = allItems.filter(p => {
                if(!p.expiry) return false;
                const expDate = new Date(p.expiry);
                const diffTime = expDate - today;
                return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) <= 60;
            });

            document.getElementById('wh-count-all').innerText = allItems.length;
            document.getElementById('wh-count-low').innerText = lowItems.length;
            document.getElementById('wh-count-out').innerText = outItems.length;
            document.getElementById('wh-count-exp').innerText = expItems.length;

            let list = []; let title = "هەمی ئایتم";
            if(filter === 'all') list = allItems;
            if(filter === 'low') { list = lowItems; title = "ئایتمێن کێمبووی (Low Stock)"; }
            if(filter === 'out') { list = outItems; title = "ئایتمێن خلاس بووی (Out of Stock)"; }
            if(filter === 'expired') { list = expItems; title = "ئایتمێن بەسەرچووی (Expiring < 60 Days)"; }

            // Sort: Out of stock first
            list.sort((a, b) => {
                if (a.qty <= 0 && b.qty > 0) return -1;
                if (a.qty > 0 && b.qty <= 0) return 1;
                return 0;
            });

            document.getElementById('wh-list-title').innerText = title;
            const tbody = document.getElementById('wh-list-body'); tbody.innerHTML = '';
            list.forEach(p => {
                let statusBadge = `<span class="status-badge-ok">باشە</span>`;
                if(p.qty <= 0) statusBadge = `<span class="status-badge-out">نەما</span>`;
                else if(p.qty <= 5) statusBadge = `<span class="status-badge-low">کێمبووی</span>`;
                if(p.expiry && new Date(p.expiry) < new Date()) statusBadge += ` <span class="status-badge-exp">بەسەرچووی</span>`;
                tbody.innerHTML += `<tr><td><b>${escapeHtml(p.name)}</b></td><td>${escapeHtml(p.supplier)}</td><td style="font-weight:bold">${p.qty} دانە</td><td>${p.expiry ? p.expiry : '-'}</td><td>${statusBadge}</td></tr>`;
            });
        }

        function updateNavAlerts() {
            const allItems = db.products.filter(p => p.trackStock);
            const outItems = allItems.filter(p => p.qty <= 0);
            const today = new Date();
            const expItems = allItems.filter(p => {
                if(!p.expiry) return false;
                const expDate = new Date(p.expiry);
                const diffTime = expDate - today;
                return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) <= 60;
            });
            
            const totalAlerts = outItems.length + expItems.length;
            const navItem = document.querySelector('.nav-item[onclick="nav(\'warehouse\')"]');
            if(navItem) {
                let badge = navItem.querySelector('.nav-badge');
                if(totalAlerts > 0) {
                    if(!badge) { badge = document.createElement('span'); badge.className = 'nav-badge'; badge.style.cssText = 'background:red; color:white; padding:2px 6px; border-radius:10px; font-size:0.7rem; margin-right:auto; float:left;'; navItem.appendChild(badge); }
                    badge.innerText = totalAlerts;
                } else if(badge) { badge.remove(); }
            }
        }

        function checkExpiryPopup() {
            const today = new Date();
            const expItems = db.products.filter(p => {
                if(!p.expiry || !p.trackStock) return false;
                const expDate = new Date(p.expiry);
                const diffTime = expDate - today;
                const days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                return days <= 60; 
            });

            if(expItems.length > 0) {
                alert(`⚠️ ئاگەهداربە! \n${expItems.length} ئایتم بەرەڤ بەسەرچوونێ دچن (کێمتر ژ 2 هەیڤان):\n` + expItems.map(p => `- ${p.name} (${p.expiry})`).slice(0, 5).join('\n') + (expItems.length > 5 ? '\n... و هیتر' : ''));
            }
        }

        // --- PRODUCT MANAGEMENT ---
        function toggleSupplierInput() {
            const source = document.querySelector('input[name="p-source"]:checked').value;
            const wrapper = document.getElementById('supplier-select-wrapper');
            if(source === 'company') { wrapper.style.display = 'block'; } else { wrapper.style.display = 'none'; document.getElementById('p-supplier').value = ""; }
        }

        function calcUnitCost() {
            const totalBuyCost = parseFloat(document.getElementById('p-total-buy-cost').value) || 0;
            const itemsPerCarton = parseInt(document.getElementById('p-per-carton').value) || 1;

            if(itemsPerCarton > 0 && totalBuyCost > 0) { // Only auto-calc if user entered carton cost
                const unitCost = totalBuyCost / itemsPerCarton;
                document.getElementById('p-cost').value = Math.round(unitCost); 
            }
        }

        function renderCategorySelect() {
            const select = document.getElementById('p-cat');
            if(!select) return;
            select.innerHTML = '';
            const cats = [...new Set(db.categories || [])].sort();
            cats.forEach(c => { select.innerHTML += `<option value="${escapeHtml(c)}">${escapeHtml(c)}</option>`; });
        }

        function addCategory() {
            const newCat = prompt("ناڤێ پۆلێنێ نوی (New Category Name):");
            if(newCat && newCat.trim() !== "") {
                if(!db.categories) db.categories = [];
                if(!db.categories.includes(newCat.trim())) {
                    db.categories.push(newCat.trim()); scheduleSave(); renderCategorySelect();
                    document.getElementById('p-cat').value = newCat.trim();
                }
            }
        }

        function saveProduct(skipTransaction = false) {
            const id = document.getElementById('p-id').value;
            const name = document.getElementById('p-name').value;
            const barcode = document.getElementById('p-barcode').value;
            
            const source = document.querySelector('input[name="p-source"]:checked').value;
            let supplier = "";
            if (source === 'direct') { supplier = "Direct Store"; } 
            else if (source === 'market') {
                supplier = "General Supplies";
                if(!db.companies.some(c => c.name === "General Supplies")) { db.companies.push({ id: 999999, name: "General Supplies", phone: "-", address: "بازاڕێ گشتی", balance: 0 }); }
            } else if (source === 'company') {
                supplier = document.getElementById('p-supplier').value;
                if(!supplier) return alert("هیڤیە کۆمپانیێ دیاری بکە!");
            }

            const duplicate = db.products.find(p => 
                p.name.trim().toLowerCase() === name.trim().toLowerCase() && 
                p.supplier === supplier &&
                p.id != (id || 0)
            );

            if(duplicate) {
                alert(`⛔ ئەڤ ئایتمە (${name}) بەری نوکە یێ هاتە تۆمارکرن!`);
                return;
            }

            const price = parseFloat(document.getElementById('p-price').value) || 0;
            const cost = parseFloat(document.getElementById('p-cost').value) || 0;
            const cat = document.getElementById('p-cat').value;
            const track = document.getElementById('p-track').checked;
            const expiry = document.getElementById('p-expiry').value;
            const itemsPerCarton = parseInt(document.getElementById('p-per-carton').value) || 1; 
            const cartonCount = parseInt(document.getElementById('p-cartons').value) || 0;
            const looseItems = parseInt(document.getElementById('p-loose').value) || 0;
            // ISSUE 2 FIXED: Capture 'For Sale' flag
            const forSale = document.getElementById('p-for-sale').checked;

            const totalQty = (cartonCount * itemsPerCarton) + looseItems;

            if (!name) return alert("هیڤیە ناڤێ ئایتمی بنڤیسە!");

            const productObj = { 
                id: id ? parseInt(id) : Date.now(),
                name, barcode, supplier, price, cost, cat, trackStock: track, itemsPerCarton, expiry,
                forSale: forSale,
                qty: 0 
            };

            if(id) { 
                const index = db.products.findIndex(x => x.id == id);
                if(index > -1) {
                    productObj.qty = track ? totalQty : 0; 
                    db.products[index] = productObj;
                }
            } else { 
                // NEW ITEM LOGIC
                productObj.qty = track ? totalQty : 0;
                db.products.push(productObj); 

                // FIX: Auto-record expense for initial stock when adding a NEW item
                if (track && totalQty > 0 && !skipTransaction) {
                    const totalInitialCost = totalQty * cost;
                    if(totalInitialCost > 0) {
                        // Add to Expenses (Assuming Cash for initial setup as requested)
                        if(!db.expenses) db.expenses = [];
                        db.expenses.push({ 
                            id: Date.now(), 
                            note: `کڕینا سەرەتایی: ${name} (${supplier})`, 
                            amount: totalInitialCost, 
                            date: new Date(), 
                            user: currentUser ? currentUser.name : 'System' 
                        });
                        
                        // Add to Supply History for traceability
                        if(!db.supplies) db.supplies = [];
                        db.supplies.push({ 
                            id: Date.now(), 
                            company: supplier, 
                            prodId: productObj.id, 
                            itemName: name, 
                            qtyAdded: totalQty, 
                            totalCost: totalInitialCost, 
                            date: new Date(), 
                            type: 'cash' 
                        });
                        
                        alert(`✅ ئایتم هاتە زێدەکرن.\n💰 بڕێ ${formatCurrency(totalInitialCost)} چووە سەر مەسرەفێ.`);
                    }
                } else if (skipTransaction) {
                    alert(`✅ ئایتم هاتە پێناسەکرن (بێ مەسرەف).`);
                }
            }
            
            clearProductInputs(); scheduleSave(); renderProducts();
            
            // Update stats immediately to reflect new expense
            updateStats(); renderExpenses();
        }

        function clearProductInputs() {
            document.getElementById('p-id').value = '';
            document.getElementById('p-name').value = '';
            document.getElementById('p-barcode').value = '';
            document.getElementById('p-supplier').value = '';
            document.getElementById('p-price').value = '';
            document.getElementById('p-cost').value = ''; 
            document.getElementById('p-total-buy-cost').value = ''; 
            document.getElementById('p-cat').value = '';
            document.getElementById('p-cartons').value = '';
            document.getElementById('p-loose').value = '0';
            document.getElementById('p-per-carton').value = '';
            document.getElementById('p-expiry').value = '';
            document.getElementById('p-for-sale').checked = true; // Reset checkbox
            document.querySelector('input[name="p-source"][value="direct"]').checked = true;
            toggleSupplierInput();
        }

        function editProd(id) {
            const p = db.products.find(x => x.id === id); if (!p) return;
            document.getElementById('p-id').value = p.id;
            document.getElementById('p-name').value = p.name;
            document.getElementById('p-barcode').value = p.barcode || '';
            
            if(p.supplier === "Direct Store") { document.querySelector('input[name="p-source"][value="direct"]').checked = true; } 
            else if (p.supplier === "General Bazz Oill") { document.querySelector('input[name="p-source"][value="market"]').checked = true; } 
            else { document.querySelector('input[name="p-source"][value="company"]').checked = true; toggleSupplierInput(); document.getElementById('p-supplier').value = p.supplier; }
            toggleSupplierInput(); 

            document.getElementById('p-price').value = p.price;
            document.getElementById('p-cost').value = p.cost;
            document.getElementById('p-total-buy-cost').value = p.cost * p.itemsPerCarton; 
            
            document.getElementById('p-cat').value = p.cat;
            document.getElementById('p-track').checked = p.trackStock;
            document.getElementById('p-per-carton').value = p.itemsPerCarton;
            document.getElementById('p-expiry').value = p.expiry;
            document.getElementById('p-for-sale').checked = (p.forSale !== false); // Load 'For Sale' status

            if(p.trackStock) {
                const cartons = Math.floor(p.qty / p.itemsPerCarton);
                const loose = p.qty % p.itemsPerCarton;
                document.getElementById('p-cartons').value = cartons;
                document.getElementById('p-loose').value = loose;
            } else {
                document.getElementById('p-cartons').value = 0;
                document.getElementById('p-loose').value = 0;
            }
            document.getElementById('product-form-card').scrollIntoView({behavior: 'smooth'});
        }

        function deleteProd(id) { 
            const isActive = db.tables.some(t => t.items.some(i => i.id === id));
            if (isActive) return alert("⛔ نەشێی ڤی ئایتمی ژێ ببەی! نوکە ل سەر مێزەکێ یێ هاتیە داواکرن.");
            if(confirm('ئایتمی ژێ ببەم؟')) { db.products = db.products.filter(p => p.id !== id); scheduleSave(); renderProducts(); }
        }

        function renderProducts(searchQ = '') {
            const container = document.getElementById('product-list-container');
            const select = document.getElementById('p-supplier');
            
            select.innerHTML = '<option value="">هەڵبژێرە...</option>';
            db.companies.filter(c => c.name !== "General Supplies").forEach(c => { select.innerHTML += `<option value="${escapeHtml(c.name)}">${escapeHtml(c.name)}</option>`; });
            
            const lowerQ = searchQ.toLowerCase().trim();
            const filteredProducts = db.products.filter(p => {
                return ((p.name && p.name.toLowerCase().includes(lowerQ)) || (p.barcode && p.barcode.includes(lowerQ)) || (p.cat && p.cat.toLowerCase().includes(lowerQ)) || (p.supplier && p.supplier.toLowerCase().includes(lowerQ)));
            });

            container.innerHTML = `
                <table class="report-table" style="margin-top:10px;">
                    <thead><tr><th>ئایتم</th><th>Barcode</th><th>Category</th><th>Cost (Unit)</th><th>Price</th><th>Stock</th><th>POS</th><th>دابینکەر</th><th>کردار</th></tr></thead>
                    <tbody>
                        ${filteredProducts.map(p => `
                        <tr>
                            <td><b>${escapeHtml(p.name)}</b></td>
                            <td>${escapeHtml(p.barcode || '-')}</td>
                            <td>${escapeHtml(p.cat) || '-'}</td>
                            <td>${formatCurrency(p.cost)}</td>
                            <td>${formatCurrency(p.price)}</td>
                            <td style="color:${p.trackStock && p.qty<5 ? 'red':'black'}">${p.trackStock ? p.qty : '∞'}</td>
                            <td>${p.forSale === false ? '<span style="color:red">No</span>' : '<span style="color:green">Yes</span>'}</td>
                            <td>${escapeHtml(p.supplier)}</td>
                            <td>
                                <button class="btn btn-brand btn-sm" onclick="editProd(${p.id})"><i class="fas fa-edit"></i></button>
                                <button class="btn btn-danger btn-sm" onclick="deleteProd(${p.id})"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>`).join('')}
                    </tbody>
                </table>
            `;
            if(document.getElementById('view-pos').style.display !== 'none') { renderPOSMenu(searchQ); }
        }

        // --- DASHBOARD ---
        function updateStats() {
            const todayStr = getBusinessDate(new Date());
            // Dashboard shows GLOBAL stats usually, but let's respect role if strict
            const visibleSales = getReportSales(); 
            const todaySales = visibleSales.filter(s => getBusinessDate(new Date(s.date)) === todayStr);
            const totalSale = todaySales.reduce((sum, s) => sum + s.total, 0);
            const todayExpenses = db.expenses.filter(e => getBusinessDate(new Date(e.date)) === todayStr);
            const totalExp = todayExpenses.reduce((sum, e) => sum + e.amount, 0);

            document.getElementById('st-sales').innerText = formatCurrency(totalSale);
            document.getElementById('st-exp').innerText = formatCurrency(totalExp);
            document.getElementById('st-profit').innerText = formatCurrency(totalSale - totalExp);
            document.getElementById('st-count').innerText = todaySales.length;
        }

        function renderDashboard() {
            const container = document.getElementById('dash-tables'); container.innerHTML = '';
            db.tables.forEach(t => {
                if(t.items && t.items.length > 0) {
                     const total = t.items.reduce((a,b)=>a+b.price,0);
                     container.innerHTML += `
                     <div class="table-card busy" onclick="openTable(${t.id})" style="height:120px; padding:10px;">
                        <i class="fas fa-utensils" style="font-size:1.5rem; margin-bottom:5px;"></i>
                        <h3 style="font-size:1rem;">${escapeHtml(t.name)}</h3>
                        <small>${formatCurrency(total)}</small>
                     </div>`;
                }
            });
        }
        function renderTables() {
            const currentTableState = JSON.stringify(db.tables);
            if(currentTableState === lastTableState) return; 
            lastTableState = currentTableState;
            const grid = document.getElementById('tables-grid'); grid.innerHTML = '';
            db.tables.forEach(t => {
                const busy = t.items && t.items.length > 0;
                const total = busy ? t.items.reduce((a,b)=>a+b.price,0) : 0;
                
                if(busy) {
                    grid.innerHTML += `
                    <div class="table-card busy" onclick="openTable(${t.id})">
                        <i class="fas fa-utensils"></i>
                        <h3>${escapeHtml(t.name)}</h3>
                        <small>${formatCurrency(total)} IQD</small>
                        <div style="position:absolute; top:10px; right:10px; background:rgba(0,0,0,0.3); padding:2px 6px; border-radius:5px; font-size:0.7rem;">${t.items.length} ئایتم</div>
                    </div>`;
                } else {
                    grid.innerHTML += `
                    <div class="table-card" onclick="openTable(${t.id})">
                        <i class="fas fa-chair" style="color:#64748b"></i>
                        <h3 style="color:var(--text)">${escapeHtml(t.name)}</h3>
                        <small style="color:#64748b">ڤالا (Empty)</small>
                    </div>`;
                }
            });
        }
        function addTable() { const n = prompt("Name:"); if(n) { db.tables.push({id: Date.now(), name: n, items: []}); lastTableState = ""; scheduleSave(); renderTables(); } }
        function transferTableUI() {
            const fromName = prompt("From Table:"); if (!fromName) return; const fromTable = db.tables.find(t => t.name == fromName);
            if (!fromTable || fromTable.items.length === 0) return alert("Empty!");
            const toName = prompt("To Table:"); if (!toName) return; const toTable = db.tables.find(t => t.name == toName);
            if (!toTable) return alert("Not Found!");
            if (confirm("Move?")) { toTable.items = [...toTable.items, ...fromTable.items]; fromTable.items = []; scheduleSave(); lastTableState = ""; renderAll(); }
        }

        function printZReport() {
            printDetailedReport('daily');
        }

        // --- POS ---
        function openTable(id) {
            activeTableId = id; const t = db.tables.find(x => x.id === id);
            document.getElementById('pos-actions-default').style.display = 'block'; 
            document.getElementById('pos-active-table').innerText = t.name; document.getElementById('pos-date').innerText = new Date().toLocaleString('ku');
            document.getElementById('nav-pos').style.display = 'flex'; nav('pos'); applyPrintSettings(); renderPOSCategories(); renderPOSMenu(); renderBill();
            
            // Reset discount field when opening table
            document.getElementById('pos-discount').value = '';
        }

        function togglePosMenu() {
            const menu = document.getElementById('pos-menu-panel');
            const bill = document.getElementById('pos-bill-panel');
            menu.classList.toggle('collapsed');
            bill.classList.toggle('expanded');
        }

        function renderPOSCategories() {
            const container = document.getElementById('category-tabs');
            container.innerHTML = `<button class="cat-btn ${activeCategory === 'all' ? 'active' : ''}" onclick="setCategory('all')">هەمی</button>`;
            [...new Set(db.products.map(p => p.cat))].filter(Boolean).forEach(c => {
                container.innerHTML += `<button class="cat-btn ${activeCategory === c ? 'active' : ''}" onclick="setCategory('${escapeHtml(c)}')">${escapeHtml(c)}</button>`;
            });
        }
        function setCategory(cat) { activeCategory = cat; renderPOSCategories(); renderPOSMenu(); }
        
        function renderPOSMenu(q = '') {
            const container = document.getElementById('pos-products'); container.innerHTML = '';
            const lowerQ = q.toLowerCase();
            
            db.products.filter(p => {
                const matchesName = p.name.toLowerCase().includes(lowerQ) || (p.barcode && p.barcode.includes(lowerQ));
                const matchesCategory = (activeCategory === 'all' || p.cat === activeCategory);
                // ISSUE 2 FIXED: Only show if 'forSale' is true (or undefined/legacy)
                const isForSale = (p.forSale !== false);
                return matchesName && (lowerQ.length > 0 || matchesCategory) && isForSale;
            }).forEach(p => {
                const hasStock = !p.trackStock || p.qty > 0;
                container.innerHTML += `<div class="p-card" onclick="${hasStock ? `addToBill(${p.id})` : ''}" style="opacity:${hasStock ? 1 : 0.5}">
                    ${p.trackStock ? `<div class="qty-badge">${p.qty}</div>` : ''}<b>${escapeHtml(p.name)}</b><p>${formatCurrency(p.price)}</p></div>`;
            });
        }
        
        function addToBill(pid) {
            const prod = db.products.find(p => p.id === pid); const table = db.tables.find(t => t.id === activeTableId);
            if(prod.trackStock && prod.qty <= 0) return alert("Out of Stock!");
            if(prod.trackStock) prod.qty--;
            table.items.push({...prod, billId: Date.now()}); lastTableState = ""; 
            scheduleSave(); 

            renderBill(); renderPOSMenu(); 
        }

        // --- BARCODE SCANNER LISTENER ---
        let barcodeBuffer = '';
        let barcodeTimer;
        document.addEventListener('keydown', (e) => {
            // If user is typing in an input, ignore (unless it's the barcode field itself, but usually scanners are global)
            if(e.target.tagName === 'INPUT' && e.target.id !== 'p-barcode') return;
            
            if(e.key === 'Enter') {
                if(barcodeBuffer.length > 0) {
                    const p = db.products.find(x => x.barcode === barcodeBuffer);
                    if(p) { addToBill(p.id); }
                    barcodeBuffer = '';
                } else if (activeTableId && document.getElementById('view-pos').classList.contains('active')) {
                    processPayment();
                }
            } else if (e.key.length === 1) {
                barcodeBuffer += e.key;
                clearTimeout(barcodeTimer);
                barcodeTimer = setTimeout(() => barcodeBuffer = '', 200); // Reset if too slow (manual typing)
            }
        });

        function renderBill() {
            const table = db.tables.find(t => t.id === activeTableId); const container = document.getElementById('bill-rows'); container.innerHTML = '';
            const grouped = {}; let total = 0;
            table.items.forEach(item => { 
                total += item.price; 
                const key = item.id + '_' + (item.note || '');
                if(!grouped[key]) { grouped[key] = { ...item, count: 0, subtotal: 0, _key: key }; } 
                grouped[key].count++; 
                grouped[key].subtotal += item.price; 
            });
            Object.values(grouped).forEach(g => {
                container.innerHTML += `
                <div class="bill-row">
                    <div style="flex:1;">
                        <div style="font-size:1rem; font-weight:bold; color:var(--text);">${escapeHtml(g.name)}</div>
                        ${g.note ? `<div style="font-size:0.85rem; color:var(--info); font-style:italic;">${escapeHtml(g.note)}</div>` : ''}
                        <div style="font-size:0.8rem; color:#9ca3af;">${formatCurrency(g.price)}</div>
                    </div>
                    
                    <div class="qty-control no-print">
                        <div class="qty-btn remove" onclick="removeFromBill(${g.id}, '${(g.note||'').replace(/'/g, "\\'")}')"><i class="fas fa-minus"></i></div>
                        <span style="font-weight:bold; font-size:1.1rem; min-width:25px; text-align:center;">${g.count}</span>
                        <div class="qty-btn add" onclick="addToBill(${g.id})"><i class="fas fa-plus"></i></div>
                    </div>

                    <div style="text-align:right; min-width:90px;">
                        <div style="font-size:1.1rem; font-weight:900; color:var(--brand);">${formatCurrency(g.subtotal)}</div>
                    </div>
                    
                    <button class="btn btn-sm btn-info no-print" style="margin-right:10px; width:32px; height:32px; border-radius:10px; padding:0;" onclick="addNoteToItem(${g.id}, '${(g.note||'').replace(/'/g, "\\'")}')">
                        <i class="fas fa-comment-dots"></i>
                    </button>
                </div>`;
            });
            
            renderBillTotal();
        }
        
        // --- UPDATED DISCOUNT LOGIC (PERCENTAGE ONLY) ---
        function applyDiscountPercent(pct) {
            const table = db.tables.find(t => t.id === activeTableId);
            if (!table) return;
            let subTotal = table.items.reduce((sum, item) => sum + item.price, 0);
            
            if(pct === 0) {
                 document.getElementById('pos-discount').value = '';
            } else {
                 // Just set the percentage value in the input
                 document.getElementById('pos-discount').value = pct; // Store percentage
            }
            renderBillTotal();
        }

        function renderBillTotal() {
            const table = db.tables.find(t => t.id === activeTableId);
            if (!table) return;
            let total = table.items.reduce((sum, item) => sum + item.price, 0);
            
            // Calculate Discount as Percentage
            const discountInput = document.getElementById('pos-discount').value;
            let finalTotal = total;
            
            if(discountInput && !isNaN(discountInput)) {
                const pct = parseFloat(discountInput);
                if(pct >= 0 && pct <= 100) {
                    const discountAmount = Math.round(total * (pct / 100));
                    finalTotal = total - discountAmount;
                }
            }

            document.getElementById('bill-total').innerText = finalTotal > 0 ? formatCurrency(finalTotal) : 0;
        }

        function addNoteToItem(prodId, currentNote) {
            const note = prompt("تێبینی بنڤیسە (Add Note):", currentNote);
            if(note === null) return;
            const table = db.tables.find(t => t.id === activeTableId);
            // Update all items in this group
            table.items.forEach(item => {
                if(item.id === prodId && (item.note || '') === currentNote) {
                    item.note = note;
                }
            });
            scheduleSave(); renderBill();
        }

        function removeFromBill(prodId, note) {
            const table = db.tables.find(t => t.id === activeTableId); 
            const idx = table.items.findIndex(item => item.id === prodId && (item.note || '') === note);
            if(idx > -1) { 
                const item = table.items[idx]; const prod = db.products.find(p => p.id === item.id); 
                if(prod && prod.trackStock) prod.qty++; 
                table.items.splice(idx, 1); lastTableState = ""; 
                scheduleSave(); 
                renderBill(); renderPOSMenu(); 
            }
        }

        function cancelOrder() {
            const table = db.tables.find(t => t.id === activeTableId);
            if(table.items.length > 0 && confirm("ژێبرنا داواکاریێ؟")) {
                table.items.forEach(item => { const prod = db.products.find(p => p.id === item.id); if(prod && prod.trackStock) prod.qty++; });
                table.items = []; lastTableState = ""; scheduleSave(); nav('tables');
            }
        }

        // --- NEW PRINTING FUNCTIONALITY (PURE KURDISH & LOGO) ---
        function printContent(htmlContent) {
            const area = document.getElementById('printable-area');
            area.innerHTML = htmlContent;
            window.print();
        }

        function printKitchen() { 
             const t = db.tables.find(t => t.id === activeTableId);
             if (t.items.length === 0) return; 
             
             // Dynamic width for Kitchen too
             const width = db.settings.paperWidth || '80mm';

             const grouped = {};
             t.items.forEach(i => {
                 const key = i.id + '_' + (i.note || '');
                 if(!grouped[key]) grouped[key] = { ...i, count: 0 };
                 grouped[key].count++;
             });
             
             // Pure Kurdish (Arabic Script) - No Latin
             let html = `
             <div class="print-thermal-container" style="max-width: ${width}; width: 100%;">
                <h2 style="margin:0; font-family:'Segoe UI'">Bazz Oill</h2>
                <div class="thermal-divider"></div>
                <div class="thermal-info"><span>مێز: ${t.name}</span><span>${new Date().toLocaleTimeString()}</span></div>
                <div class="thermal-divider"></div>
                <div class="kitchen-box">
                    ${Object.values(grouped).map(g => `
                        <div class="kitchen-row"><span class="kitchen-qty">${g.count}</span><span class="kitchen-item">${g.name}</span></div>
                        ${g.note ? `<span class="kitchen-note">* ${g.note}</span>` : ''}
                    `).join('')}
                </div>
             </div>`;
             printContent(html);
        }

        function printProforma() {
            const table = db.tables.find(t => t.id === activeTableId);
            if (!table || table.items.length === 0) return;
            
            let subTotal = table.items.reduce((sum, item) => sum + item.price, 0);
            const discountInput = document.getElementById('pos-discount').value;
            let discount = 0;
            let discountPercent = 0;
            if(discountInput && !isNaN(discountInput)) {
                discountPercent = parseFloat(discountInput);
                if(discountPercent >= 0 && discountPercent <= 100) {
                    discount = Math.round(subTotal * (discountPercent / 100));
                }
            }
            const total = subTotal - discount;

            const grouped = {}; 
            table.items.forEach(i => { 
                const key = i.id + '_' + (i.note || '');
                if(!grouped[key]) grouped[key]={name:i.name, price:i.price, count:0, sub:0, note: i.note}; 
                grouped[key].count++; 
                grouped[key].sub+=i.price; 
            });

            const logoHtml = db.settings.logo ? `<img src="${db.settings.logo}" class="thermal-logo">` : '';
            const width = db.settings.paperWidth || '80mm';

            let billHtml = `
                <div class="print-thermal-container" style="max-width: ${width}; width: 100%;">
                    ${logoHtml}
                    <div class="thermal-header">
                        ${!db.settings.logo ? `<h1>${db.settings.cafeName}</h1>` : ''}
                        <p>${db.settings.cafeInfo}</p>
                        <h2 style="margin-top:5px; border:2px solid black; padding:2px;">پسوولە (Pre-Bill)</h2>
                    </div>
                    <div class="thermal-divider"></div>
                    <div class="thermal-info"><span>بەروار: ${new Date().toLocaleString('ku')}</span></div>
                    <div class="thermal-info"><span>مێز: ${table.name}</span></div>
                    <div class="thermal-divider"></div>
                    <table class="thermal-table">
                        <thead><tr><th style="text-align:right">بابەت</th><th style="text-align:center">ژمارە</th><th style="text-align:left">نرخ</th></tr></thead>
                        <tbody>
                            ${Object.values(grouped).map(g => `<tr><td class="row-item">${g.name}${g.note ? `<br><small>* ${g.note}</small>` : ''}</td><td class="row-qty">x${g.count}</td><td class="row-price">${formatCurrency(g.sub)}</td></tr>`).join('')}
                        </tbody>
                    </table>
                    <div class="thermal-divider"></div>
                    <div class="thermal-totals-rtl">
                        <div class="total-row"><span>کۆم:</span><span>${formatCurrency(subTotal)}</span></div>
                        ${discount > 0 ? `<div class="total-row"><span>داشکاندن (${discountPercent}%):</span><span>-${formatCurrency(discount)}</span></div>` : ''}
                        <div class="grand-total">کۆیێ گشتی: ${formatCurrency(total)}</div>
                    </div>
                    <div class="thermal-footer"><p>هیڤیە پارەی بدەنە کاشێری</p></div>
                </div>`;
            printContent(billHtml);
        }
        
        function processPayment() {
            const table = db.tables.find(t => t.id === activeTableId); if (table.items.length === 0) return;
            const subTotal = table.items.reduce((a,b) => a+b.price, 0); 
            
            // Handle Discount as Percentage
            const discountInput = document.getElementById('pos-discount').value;
            let discount = 0;
            let discountPercent = 0;
            
            if(discountInput && !isNaN(discountInput)) {
                discountPercent = parseFloat(discountInput);
                if(discountPercent >= 0 && discountPercent <= 100) {
                    discount = Math.round(subTotal * (discountPercent / 100));
                }
            }
            
            const total = subTotal - discount;

            // ISSUE 3 FIX: Record COGS Expense for Non-Stock Items (Direct Items)
            table.items.forEach(item => {
                const prod = db.products.find(p => p.id === item.id);
                if(prod && !prod.trackStock && prod.cost > 0) {
                    // Automatically add expense for this item's cost
                    db.expenses.push({
                        id: Date.now() + Math.random(), // Ensure unique ID
                        note: `COGS: ${prod.name}`,
                        amount: prod.cost,
                        date: new Date(),
                        user: 'System'
                    });
                }
            });

            const sale = { 
                id: Date.now(), 
                table: table.name, 
                items: [...table.items], 
                total, 
                discount,
                discountPercent,
                date: new Date(), 
                cashier: currentUser.name 
            };
            
            db.sales.push(sale); 
            
            // --- PROFESSIONAL RECEIPT DESIGN (LOGO + PURE KURDISH) ---
            const grouped = {}; 
            sale.items.forEach(i => { 
                const key = i.id + '_' + (i.note || '');
                if(!grouped[key]) grouped[key]={name:i.name, price:i.price, count:0, sub:0, note: i.note}; 
                grouped[key].count++; 
                grouped[key].sub+=i.price; 
            });
            
            const logoHtml = db.settings.logo ? `<img src="${db.settings.logo}" class="thermal-logo">` : '';
            
            // Get Paper Width from Settings (Default 80mm)
            const width = db.settings.paperWidth || '80mm';

            let billHtml = `
                <div class="print-thermal-container" style="max-width: ${width}; width: 100%;">
                    ${logoHtml}
                    <div class="thermal-header">
                        ${!db.settings.logo ? `<h1>${db.settings.cafeName}</h1>` : ''}
                        <p>${db.settings.cafeInfo}</p>
                    </div>
                    
                    <div class="thermal-divider"></div>
                    
                    <div class="thermal-info">
                        <span>بەروار: ${new Date(sale.date).toLocaleString('ku')}</span>
                    </div>
                    <div class="thermal-info">
                        <span>وەسڵ: #${sale.id.toString().slice(-4)}</span>
                        <span>مێز: ${sale.table}</span>
                    </div>

                    <div class="thermal-divider"></div>
                    
                    <table class="thermal-table">
                        <thead>
                            <tr>
                                <th style="text-align:right">بابەت</th>
                                <th style="text-align:center">ژمارە</th>
                                <th style="text-align:left">نرخ</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${Object.values(grouped).map(g => `
                            <tr>
                                <td class="row-item">${g.name}${g.note ? `<br><small>* ${g.note}</small>` : ''}</td>
                                <td class="row-qty">x${g.count}</td>
                                <td class="row-price">${formatCurrency(g.sub)}</td>
                            </tr>`).join('')}
                        </tbody>
                    </table>
                    
                    <div class="thermal-divider"></div>
                    
                    <div class="thermal-totals-rtl">
                        <div class="total-row">
                            <span>کۆم:</span>
                            <span>${formatCurrency(subTotal)}</span>
                        </div>
                        ${discount > 0 ? `
                        <div class="total-row" style="color:black">
                            <span>داشکاندن (${discountPercent}%):</span>
                            <span>-${formatCurrency(discount)}</span>
                        </div>` : ''}
                        
                        <div class="grand-total">
                            کۆیێ گشتی: ${formatCurrency(sale.total)}
                        </div>
                    </div>

                    <div class="thermal-footer">
                        <p>${db.settings.footer}</p>
                        <p>تکایە سەردانمان بکەنەوە</p>
                    </div>
                </div>
            `;
            
            // printContent(billHtml);

            table.items = []; 
            lastTableState = ""; 
            saveToDisk();
            document.getElementById('pos-discount').value = '';
            renderBill();
        }

        // --- EXPENSES & SETTINGS ---
        function renderExpenses() { 
            // Populate Dropdown
            const select = document.getElementById('e-comp-select');
            select.innerHTML = '<option value="">مەسرەفێن گشتی</option>';
            if(db.companies) {
                db.companies.forEach(c => {
                    select.innerHTML += `<option value="${escapeHtml(c.name)}">${escapeHtml(c.name)}</option>`;
                });
            }
            // Add Users for Salary Payment
            if(db.users) {
                select.innerHTML += '<optgroup label="کارمەند (Staff)">';
                db.users.forEach(u => {
                    select.innerHTML += `<option value="Salary: ${escapeHtml(u.name)}">مووچە: ${escapeHtml(u.name)}</option>`;
                });
                select.innerHTML += '</optgroup>';
            }

            // Render List
            document.getElementById('expense-list').innerHTML = db.expenses.slice().reverse().map(e => `
                <div class="card" style="padding:10px;">
                    <b>${escapeHtml(e.note)}</b> 
                    <span style="float:left;color:red">${formatCurrency(e.amount)}</span><br>
                    <small style="color:#888">${new Date(e.date).toLocaleDateString()}</small>
                </div>`).join(''); 
        }

        function saveExpense() { 
            const noteInput = document.getElementById('e-note').value;
            const amount = parseInt(document.getElementById('e-amount').value); 
            const compSelect = document.getElementById('e-comp-select').value;
            
            let finalNote = noteInput;
            if(compSelect) {
                finalNote = noteInput ? `${noteInput} (${compSelect})` : `Expense: ${compSelect}`;
            }

            if (finalNote && amount) { 
                db.expenses.push({ id: Date.now(), note: finalNote, amount, date: new Date(), user: currentUser ? currentUser.name : 'System' }); 
                
                // Clear inputs
                document.getElementById('e-note').value = '';
                document.getElementById('e-amount').value = '';
                document.getElementById('e-comp-select').value = '';
                
                scheduleSave(); 
                renderExpenses(); 
            } 
        }
        
        function savePrintSettings() { 
            db.settings.cafeName = document.getElementById('set-cafe-name').value; 
            db.settings.cafeInfo = document.getElementById('set-cafe-info').value; 
            db.settings.footer = document.getElementById('set-cafe-footer').value; 
            // Save Paper Size
            db.settings.paperWidth = document.getElementById('set-paper-size').value;
            
            // Save Telegram Settings
            if(document.getElementById('tg-bot-token')) db.settings.tgToken = document.getElementById('tg-bot-token').value;
            if(document.getElementById('tg-chat-id')) db.settings.tgChatId = document.getElementById('tg-chat-id').value;
            
            // Handle Logo Upload
            const fileInput = document.getElementById('set-cafe-logo');
            if(fileInput.files.length > 0) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    db.settings.logo = e.target.result; // Store base64
                    scheduleSave(); applyPrintSettings(); alert("هاتە پاراستن (لگەل لۆگۆی)!");
                };
                reader.readAsDataURL(fileInput.files[0]);
            } else {
                scheduleSave(); applyPrintSettings(); alert("هاتە پاراستن!");
            }
        }

        function applyPrintSettings() { 
            if(db && db.settings) { 
                document.getElementById('bill-cafe-name').innerText = db.settings.cafeName; 
                document.getElementById('bill-cafe-info').innerText = db.settings.cafeInfo; 
                document.getElementById('bill-footer-msg').innerText = db.settings.footer; 
                document.getElementById('set-paper-size').value = db.settings.paperWidth || "80mm";
                
                // Apply Telegram Settings
                if(document.getElementById('tg-bot-token')) document.getElementById('tg-bot-token').value = db.settings.tgToken || "";
                if(document.getElementById('tg-chat-id')) document.getElementById('tg-chat-id').value = db.settings.tgChatId || "";
            } 
        }

        // --- USER & SHIFT MANAGEMENT ---
        function renderUsers() {
            const list = document.getElementById('users-list');
            list.innerHTML = '';
            db.users.forEach(u => {
                list.innerHTML += `<div style="display:flex; justify-content:space-between; border-bottom:1px solid #eee; padding:5px;">
                    <span><b>${escapeHtml(u.name)}</b> (${u.role})</span>
                    ${u.role !== 'admin' ? `<button class="btn btn-danger btn-sm" onclick="removeUser(${u.id})">X</button>` : ''}
                </div>`;
            });
        }

        function addUser() {
            const name = document.getElementById('new-u-name').value;
            const pin = document.getElementById('new-u-pin').value;
            const rate = parseFloat(document.getElementById('new-u-rate').value) || 0;
            const role = document.getElementById('new-u-role').value;
            if(!name || !pin) return alert("زانیاری کێمن");
            if(db.users.some(u => u.pin === pin)) return alert("ئەڤ PIN کۆدە یێ هەی!");
            
            db.users.push({ id: Date.now(), name, pin, role, hourlyRate: rate });
            document.getElementById('new-u-name').value = '';
            document.getElementById('new-u-pin').value = '';
            document.getElementById('new-u-rate').value = '';
            scheduleSave(); renderUsers();
        }

        function removeUser(id) {
            if(confirm("کارمەندی ژێ ببەم؟")) { db.users = db.users.filter(u => u.id !== id); scheduleSave(); renderUsers(); }
        }

        function renderShifts() {
            const tbody = document.getElementById('shifts-body'); tbody.innerHTML = '';
            // Show active shifts first
            const shifts = db.shifts.slice().reverse().slice(0, 20); 
            
            shifts.forEach(s => {
                const start = new Date(s.startTime);
                const end = s.endTime ? new Date(s.endTime) : new Date();
                
                // Calculate Duration (Hours)
                const durationHrs = (end - start) / (1000 * 60 * 60);
                
                // Calculate Salary
                const rate = s.hourlyRate || 0;
                const salary = Math.round(durationHrs * rate);

                // Calculate Sales during this shift
                // Filter sales by cashier name and time range
                const shiftSales = db.sales.filter(sale => sale.cashier === s.userName && new Date(sale.date) >= start && new Date(sale.date) <= end)
                                           .reduce((sum, sale) => sum + sale.total, 0);

                tbody.innerHTML += `<tr>
                    <td><b>${escapeHtml(s.userName)}</b></td>
                    <td>${start.toLocaleTimeString()}</td>
                    <td>${s.endTime ? end.toLocaleTimeString() : '<span style="color:green">چالاک...</span>'}</td>
                    <td style="color:var(--info); font-weight:bold;">${formatCurrency(shiftSales)}</td>
                    <td style="color:var(--success); font-weight:bold;">${formatCurrency(salary)}</td>
                </tr>`;
            });
        }
        
        // --- UPDATED BACKUP FUNCTIONS (AVAILABLE FOR CASHIER TOO) ---
        function exportDB() { 
            // Allow both admin and cashier to backup
            const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(db)); 
            const a = document.createElement('a'); 
            a.href = dataStr; 
            a.download = `BazzOill_Backup_${new Date().toISOString().slice(0,10)}.json`; 
            a.click(); 
        }
        
        function backupToLocal() {
            if (!window.showSaveFilePicker) {
                alert("ئەڤ ئامێرە پشتگیریا فایلی سەرەکی ناکەت. هیڤیە Export JSON بکاربینە.");
                return;
            }
            
            try {
                const options = { 
                    suggestedName: `BazzOill_Backup_${new Date().toISOString().slice(0,10)}.json`, 
                    types: [{ description: 'JSON Database', accept: { 'application/json': ['.json'] } }] 
                };
                
                window.showSaveFilePicker(options).then(handle => {
                    handle.createWritable().then(writable => {
                        writable.write(JSON.stringify(db, null, 2));
                        writable.close();
                        alert("✅ فایلێ تە ب سەرکەفتیانە هاتە پاراستن!");
                    });
                });
            } catch (err) {
                exportDB(); // Fallback to regular export
            }
        }
        
        function archiveOldData() {
            if(!confirm("داتایێن کەڤنتر ژ 365 ڕۆژان ئەرشیف دکەی؟")) return;
            const cutoffDate = new Date(); 
            cutoffDate.setDate(cutoffDate.getDate() - 365);
            
            const oldSales = db.sales.filter(s => new Date(s.date) < cutoffDate);
            const keepSales = db.sales.filter(s => new Date(s.date) >= cutoffDate);
            
            if(oldSales.length === 0) return alert("چ داتا نینن بۆ ئەرشیفکرنێ.");
            
            if(!db.archive) db.archive = [];
            db.archive.push(...oldSales); 
            db.sales = keepSales;
            
            // Also archive old expenses
            const oldExpenses = db.expenses.filter(e => new Date(e.date) < cutoffDate);
            const keepExpenses = db.expenses.filter(e => new Date(e.date) >= cutoffDate);
            
            // Create archive for expenses if not exists
            if(!db.expensesArchive) db.expensesArchive = [];
            db.expensesArchive.push(...oldExpenses);
            db.expenses = keepExpenses;
            
            saveToDisk(); 
            alert(`${oldSales.length} وەسڵ و ${oldExpenses.length} مەسرەف چوونە د ئەرشیفێ دا.`);
        }

        // --- REPORTING (ENHANCED) ---
        function renderDailySales() { 
            const container = document.getElementById('daily-sales-list'); container.innerHTML = ''; 
            const grouped = {}; 
            getReportSales().forEach(s => { 
                const k = getBusinessDate(new Date(s.date)); 
                if(!grouped[k]) grouped[k] = {c:0, t:0}; 
                grouped[k].c++; grouped[k].t += s.total; 
            }); 
            Object.keys(grouped).reverse().forEach(d => container.innerHTML += `<tr><td>${d}</td><td>${grouped[d].c}</td><td>${formatCurrency(grouped[d].t)}</td></tr>`); 
        }
        function renderLogs() { document.getElementById('log-list').innerHTML = db.logs.map(l => `<div style="border-bottom:1px solid #eee; font-size:0.8rem;">${escapeHtml(l.action)}</div>`).join(''); }
        
        function filterHistory(q) { 
            const list = document.getElementById('sales-history-list'); list.innerHTML = ''; 
            // Search in Active Sales + Archive
            const all = getReportSales(); // Use filtered sales
            const filtered = all.filter(s => s.id.toString().includes(q) || s.table.includes(q)); 
            
            filtered.slice().reverse().forEach(s => { 
                list.innerHTML += `
                <div style="border-bottom:1px solid #ddd; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                    <div><b>#${s.id.toString().slice(-4)}</b> - ${formatCurrency(s.total)} IQD<br><span style="font-size:0.8rem; color:#666">${new Date(s.date).toLocaleString()}</span></div>
                    <div>
                        <button class="btn btn-sm btn-dark" onclick="reprintBill(${s.id})"><i class="fas fa-print"></i></button>
                        <button class="btn btn-sm btn-danger" onclick="refundSale(${s.id})"><i class="fas fa-undo"></i> Refund</button>
                    </div>
                </div>`; 
            }); 
        }
        function renderSalesHistory() { filterHistory(''); }
        function renderMonthlyReport() { 
            const container = document.getElementById('monthly-report-list'); container.innerHTML = ''; 
            const stats = {}; 
            const allSales = getReportSales(); // Use filtered sales
            allSales.forEach(s => { const key = getBusinessMonth(new Date(s.date)); if(!stats[key]) stats[key] = { sales:0, expenses:0 }; stats[key].sales += s.total; }); 
            db.expenses.forEach(e => { const key = getBusinessMonth(new Date(e.date)); if(!stats[key]) stats[key] = { sales:0, expenses:0 }; stats[key].expenses += e.amount; }); 
            Object.keys(stats).sort().reverse().forEach(key => { const s = stats[key]; const net = s.sales - s.expenses; container.innerHTML += `<tr><td>${key}</td><td style="color:var(--success)">${formatCurrency(s.sales)}</td><td style="color:var(--danger)">${formatCurrency(s.expenses)}</td><td style="font-weight:bold">${formatCurrency(net)}</td><td>-</td></tr>`; }); 
        }

        // --- REPRINT ---
        function reprintBill(id) {
            const sale = getAllSales().find(s => s.id === id);
            if(!sale) return;
            const grouped = {}; 
            sale.items.forEach(i => { 
                const key = i.id + '_' + (i.note || '');
                if(!grouped[key]) grouped[key]={name:i.name, price:i.price, count:0, sub:0, note: i.note}; 
                grouped[key].count++; 
                grouped[key].sub+=i.price; 
            });
            
            // Check logo
            const logoHtml = db.settings.logo ? `<img src="${db.settings.logo}" class="thermal-logo">` : '';
            
            const width = db.settings.paperWidth || '80mm';

            let billHtml = `
                <div class="print-thermal-container" style="max-width: ${width}; width: 100%;">
                    ${logoHtml}
                    <div class="thermal-header">
                         ${!db.settings.logo ? `<h1>${db.settings.cafeName}</h1>` : ''}
                        <p>COPY - REPRINT</p>
                    </div>
                    <div class="thermal-divider"></div>
                    <div class="thermal-info">
                        <span>بەروار: ${new Date(sale.date).toLocaleString('ku')}</span>
                    </div>
                    <div class="thermal-info">
                        <span>وەسڵ: #${sale.id.toString().slice(-4)}</span>
                    </div>
                    <div class="thermal-divider"></div>
                    <table class="thermal-table">
                        ${Object.values(grouped).map(g => `<tr><td class="row-item">${g.name}${g.note ? `<br><small>* ${g.note}</small>` : ''}</td><td class="row-qty">x${g.count}</td><td class="row-price">${formatCurrency(g.sub)}</td></tr>`).join('')}
                    </table>
                    <div class="thermal-divider"></div>
                    
                     <div class="thermal-totals-rtl">
                        <div class="total-row">
                             <span>کۆم:</span>
                            <span>${formatCurrency(sale.total + (sale.discount || 0))}</span>
                        </div>
                         ${sale.discount > 0 ? `
                        <div class="total-row">
                            <span>داشکاندن (${sale.discountPercent || 0}%):</span>
                            <span>-${formatCurrency(sale.discount)}</span>
                        </div>` : ''}
                        <div class="grand-total">کۆیێ گشتی: ${formatCurrency(sale.total)}</div>
                    </div>
                </div>
            `;
            printContent(billHtml);
        }

        function refundSale(id) {
            if(!confirm("دڵنیای ژ ژێبرنا ڤێ وەسڵێ؟\nمەواد دێ زڤڕنە مەخزەنی.")) return;
            const saleIdx = db.sales.findIndex(s => s.id === id);
            if(saleIdx === -1) return alert("وەسڵ نەهاتە دیتن (ڕەنگە ل ئەرشیفێ بیت).");
            
            const sale = db.sales[saleIdx];
            sale.items.forEach(item => {
                const prod = db.products.find(p => p.id === item.id);
                if(prod && prod.trackStock) {
                    prod.qty++;
                }
            });

            db.sales.splice(saleIdx, 1);
            scheduleSave();
            renderSalesHistory();
            updateStats();
            alert("وەسڵ هاتە ژێبرن (Refunded).");
        }

        function printExpenses() {
            const totalExp = db.expenses.reduce((a,b) => a+b.amount, 0);
            
            let html = `
                <div class="print-a4-container">
                    <div class="print-header">
                        <div>
                            <h1 style="color: #1f2937; margin: 0;">${db.settings.cafeName}</h1>
                            <p style="color:#666; margin: 5px 0;">${db.settings.cafeInfo}</p>
                        </div>
                        <div style="text-align:right">
                            <h2 style="color: #1f2937; margin: 0;">ڕاپۆرتا مەسرەفان</h2>
                            <p style="color:#6b7280; margin: 5px 0;">بەروار: ${new Date().toLocaleDateString('ku')}</p>
                        </div>
                    </div>
                    
                    <div class="print-summary-box">
                        <div class="p-box" style="border-color: #ef4444; grid-column: span 3;">
                            <h3>کۆیێ گشتی یێ مەسرەفێ</h3>
                            <h2 style="color: #ef4444;">${formatCurrency(totalExp)} IQD</h2>
                        </div>
                    </div>

                    <div class="section-title">لیستا مەسرەفان</div>
                    <table class="print-table">
                        <thead><tr><th>بەروار</th><th>تێبینی</th><th>بەکارهێنەر</th><th>بڕ (IQD)</th></tr></thead>
                        <tbody>
                            ${db.expenses.slice().reverse().map(e => `
                                <tr>
                                    <td>${new Date(e.date).toLocaleDateString('ku')}</td>
                                    <td>${escapeHtml(e.note)}</td>
                                    <td>${escapeHtml(e.user || '-')}</td>
                                    <td style="text-align:right; color:#ef4444; font-weight:bold;">${formatCurrency(e.amount)}</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                    
                    <div class="report-footer">
                        Bazz Oill POS Pro 2026 | ڕاپۆرتا مەسرەفان
                    </div>
                </div>
            `;
            printContent(html);
        }
        
        function printLedger() {
            const comp = db.companies.find(c => c.id === currentViewingCompanyId);
            if(!comp) return;
            
            const l = db.ledger.filter(x => x.companyId === currentViewingCompanyId).reverse();
            
            let html = `
                <div class="print-a4-container">
                    <div class="print-header">
                        <div>
                            <h1 style="color: #1f2937; margin: 0;">${db.settings.cafeName}</h1>
                            <p style="color:#666; margin: 5px 0;">${db.settings.cafeInfo}</p>
                        </div>
                        <div style="text-align:right">
                            <h2 style="color: #1f2937; margin: 0;">کەشف حیساب (Ledger)</h2>
                            <p style="color:#6b7280; margin: 5px 0;">کۆمپانیا: ${escapeHtml(comp.name)}</p>
                        </div>
                    </div>
                    
                    <div class="print-summary-box">
                        <div class="p-box" style="border-color: #3b82f6;">
                            <h3>قەرزێ مای</h3>
                            <h2 style="color: #dc2626;">${formatCurrency(comp.balance)} IQD</h2>
                        </div>
                    </div>

                    <div class="section-title">وردەکاریێن لڤینان</div>
                    <table class="print-table">
                        <thead><tr><th>بەروار</th><th>جۆر</th><th>تێبینی</th><th>بڕ (IQD)</th></tr></thead>
                        <tbody>
                            ${l.map(x => {
                                const isDebt = x.type === 'credit_purchase';
                                const typeLabel = isDebt ? 'وەرگرتن (قەرز)' : 'دانەڤا پارەی';
                                const color = isDebt ? '#dc2626' : '#059669';
                                return `
                                <tr>
                                    <td>${new Date(x.date).toLocaleDateString('ku')}</td>
                                    <td style="color:${color}; font-weight:bold;">${typeLabel}</td>
                                    <td>${escapeHtml(x.note)}</td>
                                    <td style="text-align:right; font-weight:bold;">${formatCurrency(x.amount)}</td>
                                </tr>
                                `;
                            }).join('')}
                        </tbody>
                    </table>
                    
                    <div class="report-footer">
                        Bazz Oill POS Pro 2026 | ڕاپۆرتا جەردێ
                    </div>
                </div>
            `;
            printContent(html);
        }

        // --- DETAILED REPORT (A4 DESIGN) - ENHANCED ---
        function printDetailedReport(type) {
            const today = getBusinessDate(new Date());
            const thisMonth = getBusinessMonth(new Date());
            let allSales = getReportSales(); // Use filtered sales
            const scope = document.getElementById('report-scope').value;
            
            // Filter by Scope
            if(scope === 'cafe') {
                allSales = allSales.filter(s => s.table !== 'Car Wash');
            } else if (scope === 'carwash') {
                allSales = allSales.filter(s => s.table === 'Car Wash');
            }
            
            let filteredSales = [];
            let filteredExpenses = [];
            let title = "";
            let scopeText = scope === 'all' ? 'گشتی' : (scope === 'cafe' ? 'کافتریا' : 'شوشتن');

            if(type === 'daily') {
                filteredSales = allSales.filter(s => getBusinessDate(new Date(s.date)) === today);
                filteredExpenses = db.expenses.filter(e => getBusinessDate(new Date(e.date)) === today);
                title = `ڕاپۆرتا ڕۆژانە (${scopeText}): ${today}`;
            } else {
                filteredSales = allSales.filter(s => getBusinessMonth(new Date(s.date)) === thisMonth);
                filteredExpenses = db.expenses.filter(e => getBusinessMonth(new Date(e.date)) === thisMonth);
                title = `ڕاپۆرتا هەیڤانە (${scopeText}): ${thisMonth}`;
            }

            const itemCounts = {};
            const staffStats = {};
            let totalRevenue = 0;
            
            filteredSales.forEach(s => {
                totalRevenue += s.total;
                s.items.forEach(i => {
                    const safeName = escapeHtml(i.name);
                    if(!itemCounts[safeName]) itemCounts[safeName] = { qty: 0, total: 0 };
                    itemCounts[safeName].qty++;
                    itemCounts[safeName].total += i.price;
                });
                
                // Track Staff Performance
                const cName = s.cashier || 'Unknown';
                if(!staffStats[cName]) staffStats[cName] = { count: 0, total: 0 };
                staffStats[cName].count++;
                staffStats[cName].total += s.total;
            });

            const totalExp = filteredExpenses.reduce((a,b) => a+b.amount, 0);
            const net = totalRevenue - totalExp;

            // A4 HTML GENERATION - ENHANCED
            let html = `
                <div class="print-a4-container">
                    <div class="print-header">
                        <div>
                            <h1 style="color: #1f2937; margin: 0;">${db.settings.cafeName}</h1>
                            <p style="color:#666; margin: 5px 0;">${db.settings.cafeInfo}</p>
                        </div>
                        <div style="text-align:right">
                            <h2 style="color: #1f2937; margin: 0;">${title}</h2>
                            <p style="color:#6b7280; margin: 5px 0;">بەروار: ${new Date().toLocaleDateString('ku')}</p>
                        </div>
                    </div>
                    
                    <div class="print-summary-box">
                        <div class="p-box" style="border-color: #10b981;">
                            <h3>کۆیێ فرۆشتنێ</h3>
                            <h2 style="color: #10b981;">${formatCurrency(totalRevenue)} IQD</h2>
                        </div>
                        <div class="p-box" style="border-color: #ef4444;">
                            <h3>کۆیێ مەسرەفێ</h3>
                            <h2 style="color: #ef4444;">${formatCurrency(totalExp)} IQD</h2>
                        </div>
                        <div class="p-box" style="background:#f0f9ff; border-color: #3b82f6;">
                            <h3>مفایێ سافی</h3>
                            <h2 style="color: #1f2937;">${formatCurrency(net)} IQD</h2>
                        </div>
                    </div>

                    <div class="section-title">١. فرۆشتن ل دویڤ ئایتمی</div>
                    <table class="print-table">
                        <thead><tr><th>ئایتم</th><th>ژمارە</th><th>کۆیێ بهای</th></tr></thead>
                        <tbody>
                            ${Object.keys(itemCounts).map(k => `
                                <tr>
                                    <td><b>${k}</b></td>
                                    <td style="text-align:center; font-weight:bold;">${itemCounts[k].qty}</td>
                                    <td style="text-align:right; font-weight:bold;">${formatCurrency(itemCounts[k].total)} IQD</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                    
                    <div class="section-title">٢. چالاکیێن کارمەندان (Staff Performance)</div>
                    <table class="print-table">
                        <thead><tr><th>کارمەند</th><th>ژمارا وەسڵان</th><th>کۆیێ فرۆشتنێ</th></tr></thead>
                        <tbody>
                            ${Object.keys(staffStats).map(k => `
                                <tr>
                                    <td><b>${k}</b></td>
                                    <td style="text-align:center;">${staffStats[k].count}</td>
                                    <td style="text-align:right; font-weight:bold;">${formatCurrency(staffStats[k].total)} IQD</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>

                    <div class="section-title">٣. مەسرەف</div>
                     <table class="print-table">
                        <thead><tr><th>تێبینی</th><th>بڕ (IQD)</th></tr></thead>
                        <tbody>
                            ${filteredExpenses.map(e => `<tr><td>${escapeHtml(e.note)}</td><td style="text-align:right; color:#ef4444;">${formatCurrency(e.amount)}</td></tr>`).join('')}
                            ${filteredExpenses.length === 0 ? '<tr><td colspan="2" style="text-align:center; color:#999;">چ مەسرەف نینن</td></tr>' : ''}
                        </tbody>
                    </table>

                    <div class="section-title">٤. وەسڵ</div>
                    <table class="print-table">
                        <thead><tr><th>ژمارا وەسڵێ</th><th>مێز</th><th>کۆیێ بهای</th><th>دەم</th></tr></thead>
                        <tbody>
                            ${filteredSales.slice().reverse().map(s => `
                                <tr>
                                    <td>#${s.id.toString().slice(-4)}</td>
                                    <td>${escapeHtml(s.table)}</td>
                                    <td style="text-align:right;">${formatCurrency(s.total)} IQD</td>
                                    <td>${new Date(s.date).toLocaleTimeString('ku', {hour: '2-digit', minute:'2-digit'})}</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>

                    <div class="report-footer">
                        Bazz Oill POS Pro 2026 | دەمێ دەرخستنێ: ${new Date().toLocaleString('ku')}
                    </div>
                </div>
            `;

            printContent(html);
        }
        
        function printDebtReport() {
            const companiesWithDebt = db.companies.filter(c => c.balance > 0);
            let totalDebt = 0;
            companiesWithDebt.forEach(c => totalDebt += c.balance);
            
            let html = `
                <div class="print-a4-container">
                    <div class="print-header">
                        <div>
                            <h1 style="color: #1f2937; margin: 0;">${db.settings.cafeName}</h1>
                            <p style="color:#666; margin: 5px 0;">${db.settings.cafeInfo}</p>
                        </div>
                        <div style="text-align:right">
                            <h2 style="color: #1f2937; margin: 0;">ڕاپۆرتا قەرزان</h2>
                            <p style="color:#6b7280; margin: 5px 0;">بەروار: ${new Date().toLocaleDateString('ku')}</p>
                        </div>
                    </div>
                    
                    <div class="print-summary-box">
                        <div class="p-box" style="border-color: #dc2626; background: #fef2f2;">
                            <h3>کۆمێ قەرزێ گشتی</h3>
                            <h2 style="color: #dc2626;">${formatCurrency(totalDebt)} IQD</h2>
                        </div>
                        <div class="p-box" style="border-color: #d97706; background: #fffbeb;">
                            <h3>ژمارا کۆمپانیێن قەرزدار</h3>
                            <h2 style="color: #d97706;">${companiesWithDebt.length}</h2>
                        </div>
                        <div class="p-box" style="border-color: #059669; background: #ecfdf5;">
                            <h3>کۆمپانیێن بێ قەرز</h3>
                            <h2 style="color: #059669;">${db.companies.length - companiesWithDebt.length}</h2>
                        </div>
                    </div>

                    <div class="section-title">لیستا قەرزان</div>
                    <table class="print-table">
                        <thead><tr><th>کۆمپانیا</th><th>ژمارا تەلەفۆنێ</th><th>بڕێ قەرزی (IQD)</th><th>ناڤنیشان</th></tr></thead>
                        <tbody>
                            ${companiesWithDebt.map(c => `
                                <tr>
                                    <td><b>${escapeHtml(c.name)}</b></td>
                                    <td>${escapeHtml(c.phone)}</td>
                                    <td style="text-align:right; color:#dc2626; font-weight:bold;">${formatCurrency(c.balance)}</td>
                                    <td>${escapeHtml(c.address)}</td>
                                </tr>
                            `).join('')}
                            ${companiesWithDebt.length === 0 ? '<tr><td colspan="4" style="text-align:center; color:#999; padding:30px;">چ قەرز نینن</td></tr>' : ''}
                        </tbody>
                    </table>

                    <div class="report-footer">
                        Bazz Oill POS Pro 2026 | ڕاپۆرتا قەرزان
                    </div>
                </div>
            `;
            
            printContent(html);
        }

        // --- TELEGRAM & PDF FUNCTIONS ---

        async function generatePDFBlob() {
            // 1. Generate the HTML content for the report
            const today = getBusinessDate(new Date());
            const allSales = getReportSales();
            const filteredSales = allSales.filter(s => getBusinessDate(new Date(s.date)) === today);
            const filteredExpenses = db.expenses.filter(e => getBusinessDate(new Date(e.date)) === today);
            
            let totalRev = filteredSales.reduce((sum, s) => sum + s.total, 0);
            let totalExp = filteredExpenses.reduce((sum, e) => sum + e.amount, 0);
            let net = totalRev - totalExp;

            // Create a temporary container for the PDF content
            const tempDiv = document.createElement('div');
            tempDiv.style.width = '210mm';
            tempDiv.style.padding = '20mm';
            tempDiv.style.background = 'white';
            tempDiv.style.color = 'black';
            tempDiv.style.position = 'absolute';
            tempDiv.style.top = '-9999px';
            tempDiv.style.left = '-9999px';
            tempDiv.style.direction = 'rtl';
            tempDiv.style.fontFamily = 'Segoe UI, Tahoma, sans-serif';
            
            tempDiv.innerHTML = `
                <div style="text-align:center; border-bottom:2px solid black; padding-bottom:10px; margin-bottom:20px;">
                    <h1>${db.settings.cafeName}</h1>
                    <p>Raporta Rojane: ${today}</p>
                    <p>Karmand (Cashier): ${currentUser ? currentUser.name : 'Unknown'}</p>
                </div>
                <div style="display:flex; justify-content:space-between; margin-bottom:20px; font-size:1.2rem; font-weight:bold;">
                    <div style="color:green">Frotin: ${formatCurrency(totalRev)}</div>
                    <div style="color:red">Mesref: ${formatCurrency(totalExp)}</div>
                    <div style="color:blue">Safi: ${formatCurrency(net)}</div>
                </div>
                <h3>Kurtiya Frotine (Sales)</h3>
                <table style="width:100%; border-collapse:collapse; margin-bottom:20px;">
                    <tr style="background:#eee;"><th>Jimare</th><th>Dem</th><th>Kom</th></tr>
                    ${filteredSales.map(s => `<tr><td style="border:1px solid #ddd; padding:5px;">#${s.id.toString().slice(-4)}</td><td style="border:1px solid #ddd; padding:5px;">${new Date(s.date).toLocaleTimeString()}</td><td style="border:1px solid #ddd; padding:5px;">${formatCurrency(s.total)}</td></tr>`).join('')}
                </table>
                <h3>Mesref (Expenses)</h3>
                <table style="width:100%; border-collapse:collapse;">
                    <tr style="background:#eee;"><th>Tebini</th><th>Ko</th></tr>
                    ${filteredExpenses.map(e => `<tr><td style="border:1px solid #ddd; padding:5px;">${escapeHtml(e.note)}</td><td style="border:1px solid #ddd; padding:5px;">${formatCurrency(e.amount)}</td></tr>`).join('')}
                </table>
            `;
            
            document.body.appendChild(tempDiv);
            
            // Use html2canvas to capture the div
            const canvas = await html2canvas(tempDiv, { scale: 2 });
            document.body.removeChild(tempDiv);
            
            const imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgProps = pdf.getImageProperties(imgData);
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
            
            pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
            return pdf.output('blob');
        }

        async function downloadPDFReport() {
            const blob = await generatePDFBlob();
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = `Report_${new Date().toISOString().slice(0,10)}.pdf`;
            link.click();
        }

        async function sendTelegramReport() {
            // Save settings first
            savePrintSettings();
            const token = db.settings.tgToken;
            const chatId = db.settings.tgChatId;
            
            if(!token || !chatId) return alert("هیڤیە سەرەتا Token و Chat ID دابنێ!");
            await sendFilesToTelegram(token, chatId);
        }

        async function manualTelegramSend() {
            const chatId = prompt("Chat ID بنڤیسە (بۆ ناردن):");
            if(!chatId) return;
            const token = db.settings.tgToken || prompt("Bot Token بنڤیسە:");
            if(!token) return;
            
            await sendFilesToTelegram(token, chatId);
        }

        async function sendFilesToTelegram(token, chatIdsInput) {
            if (!navigator.onLine) {
                alert("❌ ئینتەرنێت نینە! (No Internet Connection)");
                return;
            }

            const indicator = document.getElementById('save-indicator');
            indicator.style.display = 'block'; indicator.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ناردن بۆ تێلیگرامی...';
            
            try {
                // Split Chat IDs by comma and trim whitespace
                const chatIds = chatIdsInput.split(',').map(id => id.trim()).filter(id => id);
                
                // 1. Send JSON Backup
                const jsonBlob = new Blob([JSON.stringify(db)], { type: 'application/json' });
                // 2. Send PDF Report
                const pdfBlob = await generatePDFBlob();

                for (const chatId of chatIds) {
                    // Send JSON
                    const formDataJson = new FormData();
                    formDataJson.append('chat_id', chatId);
                    formDataJson.append('document', jsonBlob, `Backup_${new Date().toISOString().slice(0,10)}.json`);
                    await fetch(`https://api.telegram.org/bot${token}/sendDocument`, { method: 'POST', body: formDataJson });

                    // Send PDF
                    const formDataPdf = new FormData();
                    formDataPdf.append('chat_id', chatId);
                    formDataPdf.append('document', pdfBlob, `Report_${new Date().toISOString().slice(0,10)}.pdf`);
                    await fetch(`https://api.telegram.org/bot${token}/sendDocument`, { method: 'POST', body: formDataPdf });
                }

                alert("✅ ڕاپۆرت و باک ئەپ هاتنە ناردن!");
            } catch (err) {
                if (err.message.includes('Failed to fetch')) {
                    alert("❌ کێشەیا ئینتەرنێتێ! (Network Error - Failed to fetch)");
                } else {
                    alert("❌ هەڵە: " + err.message);
                }
            } finally {
                indicator.style.display = 'none';
            }
        }

        // --- CAR WASH LOGIC ---

        function setupCarWashAccounts() {
            if (!db.companies.some(c => c.name === 'Car Wash (Taxi)')) {
                db.companies.push({ id: Date.now(), name: 'Car Wash (Taxi)', phone: 'N/A', address: 'Taxi Fleet Account', balance: 0 });
            }
            if (!db.companies.some(c => c.name === 'Car Wash (Private)')) {
                db.companies.push({ id: Date.now() + 1, name: 'Car Wash (Private)', phone: 'N/A', address: 'Private Customer Accounts', balance: 0 });
            }
        }

        function renderCarWash() {
            if (!db || !db.carwash) return;
            setupCarWashAccounts();

            // 1. Populate services dropdown
            const serviceSelect = document.getElementById('cw-service');
            serviceSelect.innerHTML = '<option value="">-- خزمەتگوزاریێ هەڵبژێرە --</option>';
            db.carwash.services.forEach(s => {
                serviceSelect.innerHTML += `<option value="${s.id}" data-price="${s.price}">${escapeHtml(s.name)}</option>`;
            });
            serviceSelect.innerHTML += '<option value="custom">-- بهایێ جیاواز --</option>';

            // Add event listener to update price
            serviceSelect.onchange = () => {
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                const priceInput = document.getElementById('cw-price');
                if (selectedOption.value && selectedOption.value !== 'custom') {
                    priceInput.value = selectedOption.dataset.price;
                    priceInput.readOnly = false;
                } else {
                    priceInput.value = '';
                    priceInput.readOnly = false;
                    priceInput.focus();
                }
            };

            // 2. Render lists
            const inProgressList = document.getElementById('carwash-inprogress-list');
            const doneList = document.getElementById('carwash-done-list');
            inProgressList.innerHTML = '';
            doneList.innerHTML = '';

            const queue = db.carwash.queue || [];
            queue.forEach(car => {
                const cardHtml = `
                    <div class="carwash-card ${car.status}">
                        <div>
                            <h4 style="margin:0;">${escapeHtml(car.plate)} <span style="font-size:0.8rem; background: var(--input-bg); padding: 2px 8px; border-radius: 5px;">${escapeHtml(car.vehicleType)}</span></h4>
                            <p style="margin:5px 0; font-size:0.9rem; color:#9ca3af;">${escapeHtml(car.serviceName)}</p>
                            <b style="color:var(--brand);">${formatCurrency(car.price)} IQD</b>
                            <p style="margin:5px 0; font-size:0.8rem; color: ${car.paymentMethod === 'account' ? 'var(--warning)' : 'var(--success)'};">${car.paymentMethod === 'account' ? 'قەرز' : 'نەقد'}</p>
                        </div>
                        <div id="cw-actions-${car.id}" style="display:flex; flex-direction:column; gap:5px;">
                            ${car.status === 'washing' ? `
                                <button class="btn btn-success" onclick="updateCarWashStatus(${car.id}, 'done')"><i class="fas fa-check"></i> تەمام بوو</button>
                                <button class="btn btn-sm btn-danger" onclick="cancelCarWash(${car.id})"><i class="fas fa-times"></i> هەڵوەشاندن</button>
                            ` : `
                                <button class="btn btn-brand" onclick="completeCarWash(${car.id})"><i class="fas fa-money-bill-wave"></i> وەرگرتنا پارەی</button>
                                <button class="btn btn-sm btn-dark" onclick="updateCarWashStatus(${car.id}, 'washing')"><i class="fas fa-undo"></i> زڤڕاندن</button>
                            `}
                        </div>
                    </div>
                `;
                if (car.status === 'washing') {
                    inProgressList.innerHTML += cardHtml;
                } else if (car.status === 'done') {
                    doneList.innerHTML += cardHtml;
                }
            });
        }

        function addCarToWashQueue() {
            const plate = document.getElementById('cw-plate').value.trim();
            const vehicleType = document.getElementById('cw-vehicle-type').value;
            const serviceSelect = document.getElementById('cw-service');
            const priceInput = document.getElementById('cw-price');
            const paymentMethod = document.querySelector('input[name="cw-payment"]:checked').value;
            const price = parseFloat(priceInput.value);

            if (!plate) return alert('هیڤیە ژمارا تابلۆیێ بنڤیسە.');
            if (!price || price <= 0) return alert('هیڤیە خزمەتگوزاریێ هەڵبژێرە یان بهایەکێ بنڤیسە.');
            
            const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            const serviceName = selectedOption.value && selectedOption.value !== 'custom' ? selectedOption.text : 'Custom Service';
            
            if(!db.carwash.queue) db.carwash.queue = [];

            db.carwash.queue.push({ 
                id: Date.now(), 
                plate: plate, 
                vehicleType: vehicleType,
                serviceName: serviceName, 
                price: price, 
                status: 'washing', // New cars are always 'washing'
                paymentMethod: paymentMethod,
                startTime: new Date() 
            });

            // Reset form
            document.getElementById('cw-plate').value = '';
            serviceSelect.value = '';
            priceInput.value = '';
            priceInput.readOnly = false;
            
            scheduleSave();
            renderCarWash();
        }

        function updateCarWashStatus(carId, newStatus) {
            const car = db.carwash.queue.find(c => c.id === carId);
            if (car) {
                car.status = newStatus;
                if (newStatus === 'done') car.endTime = new Date();
                else delete car.endTime;
                scheduleSave();
                renderCarWash();
            }
        }

        function cancelCarWash(carId) {
            if (confirm('دڵنیای تە دڤێت هەڵبوەشینی؟')) {
                if(!db.carwash.queue) db.carwash.queue = [];
                db.carwash.queue = db.carwash.queue.filter(c => c.id !== carId);
                scheduleSave();
                renderCarWash();
            }
        }

        async function sendTelegramMessage(message, token, chatId) {
            if (!navigator.onLine) return;

            const url = `https://api.telegram.org/bot${token}/sendMessage`;
            const formData = new FormData();
            formData.append('chat_id', chatId);
            formData.append('text', message);
            formData.append('parse_mode', 'HTML');
            try {
                const response = await fetch(url, { method: 'POST', body: formData });
                const result = await response.json();
                if (!result.ok) console.error('Telegram API Error:', result.description);
            } catch (err) {
                console.error('Failed to send Telegram message:', err);
            }
        }

        async function completeCarWash(carId) {
            const carIndex = db.carwash.queue.findIndex(c => c.id === carId);
            if (carIndex === -1) return;
            
            const car = db.carwash.queue[carIndex];
            let saleRecord;
            let alertMessage = "";
            let tgMessage = "";

            if (car.paymentMethod === 'account') {
                const accountName = car.vehicleType === 'Taxi' ? 'Car Wash (Taxi)' : 'Car Wash (Private)';
                const company = db.companies.find(c => c.name === accountName);
                if (company) {
                    company.balance += car.price;
                    
                    if(!db.ledger) db.ledger = [];
                    db.ledger.push({
                        id: Date.now(),
                        companyId: company.id,
                        type: 'credit_purchase',
                        amount: car.price,
                        date: new Date(),
                        note: `Car Wash: ${car.plate} (${car.serviceName})`
                    });

                    alertMessage = `✅ شوشتن بۆ ${car.plate} تەمام بوو. چووە سەر حیسابا ${accountName}.`;
                    tgMessage = `🧼 <b>شوشتن (قەرز)</b>\n\n🚗 تابلۆ: <b>${escapeHtml(car.plate)}</b>\n🚙 جۆر: ${escapeHtml(car.vehicleType)}\n🚿 خزمەت: ${escapeHtml(car.serviceName)}\n💰 بها: <b>${formatCurrency(car.price)} IQD</b>\n➡️ چووە سەر حیسابا ${accountName}.\n👤 کاشێر: ${currentUser.name}\n\n🕒 دەم: ${new Date().toLocaleString('ku')}`;

                } else {
                    alert(`هەڵە: حیسابا '${accountName}' نەهاتە دیتن.`);
                    return;
                }
            } else { // Cash payment
                saleRecord = { 
                    id: Date.now(), 
                    table: `Car Wash`, 
                    items: [{ id: car.id, name: `Car Wash: ${car.serviceName} (${car.plate})`, price: car.price, cost: 0, cat: 'Car Wash Services' }], 
                    total: car.price, 
                    discount: 0, 
                    discountPercent: 0, 
                    date: new Date(), 
                    cashier: currentUser.name 
                };
                db.sales.push(saleRecord);
                alertMessage = `پارەدان بۆ ${car.plate} تەمام بوو.`;
                tgMessage = `✅ <b>شوشتن (نەقد)</b>\n\n🚗 تابلۆ: <b>${escapeHtml(car.plate)}</b>\n🚙 جۆر: ${escapeHtml(car.vehicleType)}\n🚿 خزمەت: ${escapeHtml(car.serviceName)}\n💰 بها: <b>${formatCurrency(car.price)} IQD</b>\n👤 کاشێر: ${currentUser.name}\n\n🕒 دەم: ${new Date().toLocaleString('ku')}`;
            }

            const token = db.settings.tgToken;
            const chatIds = (db.settings.tgChatId || '').split(',').map(id => id.trim()).filter(id => id);
            if (token && chatIds.length > 0) {
                // Send in background before printing to ensure immediate delivery
                chatIds.forEach(chatId => sendTelegramMessage(tgMessage, token, chatId));
            }

            printCarWashReceipt(car);

            db.carwash.queue.splice(carIndex, 1);
            scheduleSave();
            renderCarWash();
            updateStats();
            alert(alertMessage);
        }

        function printCarWashReceipt(car) {
            const width = db.settings.paperWidth || '80mm';
            const logoHtml = db.settings.logo ? `<img src="${db.settings.logo}" class="thermal-logo">` : '';

            let billHtml = `
                <div class="print-thermal-container" style="max-width: ${width}; width: 100%;">
                    ${logoHtml}
                    <div class="thermal-header">
                        ${!db.settings.logo ? `<h1>${db.settings.cafeName}</h1>` : ''}
                        <p>${db.settings.cafeInfo}</p>
                        <h2 style="margin-top:5px; border:2px solid black; padding:2px;">وەسڵا شوشتنێ</h2>
                    </div>
                    <div class="thermal-divider"></div>
                    <div class="thermal-info"><span>بەروار: ${new Date().toLocaleString('ku')}</span></div>
                    <div class="thermal-info"><span>کاشێر: ${currentUser.name}</span></div>
                    <div class="thermal-divider"></div>
                    
                    <div class="thermal-totals-rtl" style="text-align:center; margin-bottom: 10px;">
                        <div class="total-row" style="font-size: 1.1rem;"><span>ژمارا تابلۆیێ:</span><span style="font-weight:bold;">${escapeHtml(car.plate)}</span></div>
                        <div class="total-row"><span>جۆرێ ترومبێلێ:</span><span>${escapeHtml(car.vehicleType)}</span></div>
                    </div>

                    <div class="thermal-divider"></div>
                    <table class="thermal-table">
                        <thead><tr><th style="text-align:right">خزمەتگوزاری</th><th style="text-align:left">بها</th></tr></thead>
                        <tbody>
                            <tr>
                                <td class="row-item">${escapeHtml(car.serviceName)}</td>
                                <td class="row-price">${formatCurrency(car.price)}</td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="thermal-divider"></div>
                    <div class="thermal-totals-rtl">
                        <div class="grand-total">
                            کۆیێ گشتی: ${formatCurrency(car.price)} IQD
                        </div>
                        <div class="total-row" style="justify-content: center; margin-top: 5px; font-weight: bold;">
                           پارەدان: ${car.paymentMethod === 'account' ? 'قەرز' : 'نەقد'}
                        </div>
                    </div>
                    <div class="thermal-footer"><p>${db.settings.footer}</p></div>
                </div>`;
            printContent(billHtml);
        }

        function renderCarWashServicesSettings() {
            const list = document.getElementById('cw-services-list');
            if (!list) return;
            list.innerHTML = '';
            if (!db.carwash || !db.carwash.services) return;

            db.carwash.services.forEach(s => {
                list.innerHTML += `<div style="display:flex; justify-content:space-between; border-bottom:1px solid var(--border); padding:8px 5px;">
                    <span><b>${escapeHtml(s.name)}</b> - ${formatCurrency(s.price)} IQD</span>
                    <button class="btn btn-danger btn-sm" onclick="deleteCarWashService(${s.id})">X</button>
                </div>`;
            });
        }

        function addCarWashService() {
            const nameInput = document.getElementById('cw-service-name');
            const priceInput = document.getElementById('cw-service-price');
            const name = nameInput.value.trim();
            const price = parseFloat(priceInput.value);

            if (!name || !price || price <= 0) {
                return alert("هیڤیە ناڤ و بهایەکێ دروست بنڤیسە.");
            }

            if (!db.carwash.services) db.carwash.services = [];

            db.carwash.services.push({
                id: Date.now(),
                name: name,
                price: price
            });

            nameInput.value = '';
            priceInput.value = '';
            scheduleSave();
            renderCarWashServicesSettings();
        }

        function deleteCarWashService(serviceId) {
            if (confirm("دڵنیای تە دڤێت ژێ ببەی؟")) {
                db.carwash.services = db.carwash.services.filter(s => s.id !== serviceId);
                scheduleSave();
                renderCarWashServicesSettings();
            }
        }
    </script>
</body>
</html>
